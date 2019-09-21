import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import '../communication/connection.dart';
import '../communication/errors.dart';
import '../communication/requests/request_collection.dart';
import '../hazizz_date.dart';
import '../hazizz_response.dart';
import '../request_sender.dart';

//region EditTask bloc parts
//region EditTask events
abstract class TasksCalendarEvent extends HEvent {
  TasksCalendarEvent([List props = const []]) : super(props);
}

class TasksCalendarFetchEvent extends TasksCalendarEvent {
  /*
  bool finishedOnly = true;
  bool unfinishedOnly = false;

  bool expired = false;
  */


  TasksCalendarFetchEvent(/*{this.unfinishedOnly, this.expired}*/) :  super([/*unfinishedOnly*/]){

  }
  @override
  String toString() => 'TasksCalendarFetchEvent';
}
//endregion

//region SubjectItemListStates
abstract class TasksCalendarState extends HState {
  TasksCalendarState([List props = const []]) : super(props);
}

class TasksCalendarInitialState extends TasksCalendarState {
  @override
  String toString() => 'TasksCalendarInitialState';
}

class TasksCalendarWaitingState extends TasksCalendarState {
  @override
  String toString() => 'TasksCalendarWaitingState';
}



class TasksCalendarLoadedState extends TasksCalendarState {
  Map<DateTime, List<PojoTask>> tasks;

  TasksCalendarLoadedState(this.tasks) : assert(tasks!= null), super([tasks]);
  @override
  String toString() => 'TasksCalendarLoadedState';
}

class TasksCalendarLoadedCacheState extends TasksCalendarState {
  Map<DateTime, List<PojoTask>> tasks;

  TasksCalendarLoadedCacheState(this.tasks) : assert(tasks!= null), super([tasks]);
  @override
  String toString() => 'TasksCalendarLoadedCacheState';
}

class TasksCalendarErrorState extends TasksCalendarState {
  HazizzResponse hazizzResponse;
  TasksCalendarErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'TasksCalendarErrorState';
}


//endregion

//region SubjectItemListBloc
class TasksCalendarBloc extends Bloc<TasksCalendarEvent, TasksCalendarState> {

  TasksCalendarBloc(){}

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  List<PojoTask> tasksRaw;

  Map<DateTime, List<PojoTask>> tasks;

  Map<DateTime, List<PojoTask>> onLoaded(List<PojoTask> t){
    tasks = null;
    if(tasks == null || tasks.isEmpty){
      tasks = Map();
      int i = 0;
      for(PojoTask task in t){
        if (i == 0 || t[i].dueDate
            .difference(t[i - 1].dueDate)
            .inDays >= 1) {
          tasks[t[i].dueDate] = List();
          tasks[t[i].dueDate].add(task);

        }else{
          tasks[t[i].dueDate].add(task);
        }
        i++;
      }
      return tasks;
    }

  }

  @override
  TasksCalendarState get initialState => TasksCalendarInitialState();

  @override
  Stream<TasksCalendarState> mapEventToState(TasksCalendarEvent event) async* {
    if (event is TasksCalendarFetchEvent) {
      try {
        yield TasksCalendarWaitingState();

        String startDate = hazizzRequestDateFormat(DateTime.now().subtract(Duration(days: 40)));
        String endDate = hazizzRequestDateFormat(DateTime.now().add(Duration(days: 365)));

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe(q_unfinishedOnly: false, q_finishedOnly: false, q_showThera: true, q_startingDate: startDate, q_endDate: endDate));

        if(hazizzResponse.isSuccessful){

          HazizzLogger.printLog("tasks.tasks: ${ hazizzResponse.convertedData}");
          tasksRaw = hazizzResponse.convertedData;
          HazizzLogger.printLog("off: $tasksRaw");
          if(tasksRaw != null ){
            onLoaded(tasksRaw);
            HazizzLogger.printLog("oopaa1: ${tasks}");

            yield TasksCalendarLoadedState(tasks);
          }
        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            HazizzLogger.printLog("log: noConnectionError22");
            yield TasksCalendarErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.dispatch(TasksCalendarFetchEvent());
            },
                "Tasks_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            HazizzLogger.printLog("log: noConnectionError22");
            this.dispatch(TasksCalendarFetchEvent());
          }else{
            yield TasksCalendarErrorState(hazizzResponse);

          }
        }
      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }
}
//endregion
//endregion
