import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';

//region TasksCalendar bloc parts
//region TasksCalendar events
abstract class TasksCalendarEvent extends HEvent {
  TasksCalendarEvent([List props = const []]) : super(props);
}

class TasksCalendarFetchEvent extends TasksCalendarEvent {
  TasksCalendarFetchEvent() :  super([]);
  @override
  String toString() => 'TasksCalendarFetchEvent';
  List<Object> get props => null;
}
//endregion

//region TasksCalendar states
abstract class TasksCalendarState extends HState {
  TasksCalendarState([List props = const []]) : super(props);
}

class TasksCalendarInitialState extends TasksCalendarState {
  @override
  String toString() => 'TasksCalendarInitialState';
  List<Object> get props => null;
}

class TasksCalendarWaitingState extends TasksCalendarState {
  @override
  String toString() => 'TasksCalendarWaitingState';
  List<Object> get props => null;
}


class TasksCalendarLoadedState extends TasksCalendarState {
  final Map<DateTime, List<PojoTask>> tasks;

  TasksCalendarLoadedState(this.tasks) : assert(tasks!= null), super([tasks]);
  @override
  String toString() => 'TasksCalendarLoadedState';
  List<Object> get props => [tasks];
}

class TasksCalendarLoadedCacheState extends TasksCalendarState {
  final Map<DateTime, List<PojoTask>> tasks;

  TasksCalendarLoadedCacheState(this.tasks) : assert(tasks!= null), super([tasks]);
  @override
  String toString() => 'TasksCalendarLoadedCacheState';
  List<Object> get props => [tasks];
}

class TasksCalendarErrorState extends TasksCalendarState {
  final HazizzResponse hazizzResponse;
  TasksCalendarErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'TasksCalendarErrorState';
  List<Object> get props => [hazizzResponse];
}


//endregion

//region TasksCalendar bloc
class TasksCalendarBloc extends Bloc<TasksCalendarEvent, TasksCalendarState> {

  TasksCalendarBloc();

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
          if(tasks[t[i].dueDate] == null){
            tasks[t[i].dueDate] = List();
          }
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

        String startDate = DateTime.now().subtract(Duration(days: 40)).hazizzRequestDateFormat;
        String endDate = DateTime.now().add(Duration(days: 365)).hazizzRequestDateFormat;

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe(q_unfinishedOnly: false, q_finishedOnly: false, q_showThera: true, q_startingDate: startDate, q_endDate: endDate));

        if(hazizzResponse.isSuccessful){
          tasksRaw = hazizzResponse.convertedData;
          if(tasksRaw != null ){
            onLoaded(tasksRaw);

            yield TasksCalendarLoadedState(tasks);
          }
        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            yield TasksCalendarErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.add(TasksCalendarFetchEvent());
            },
                "Tasks_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            this.add(TasksCalendarFetchEvent());
          }else{
            yield TasksCalendarErrorState(hazizzResponse);

          }
        }
      } on Exception catch(e){
      }
    }
  }
}
//endregion
//endregion
