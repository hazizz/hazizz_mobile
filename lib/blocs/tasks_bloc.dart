import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/enums/task_complete_state_enum.dart';

import 'package:mobile/managers/kreta_session_manager.dart';

import '../caches/data_cache.dart';
import '../communication/connection.dart';
import '../communication/errors.dart';
import '../communication/pojos/PojoClass.dart';
import '../communication/requests/request_collection.dart';
import '../hazizz_date.dart';
import '../hazizz_response.dart';
import '../request_sender.dart';
import 'main_tab_blocs/main_tab_blocs.dart';

//region EditTask bloc parts
//region EditTask events
abstract class TasksEvent extends HEvent {
  TasksEvent([List props = const []]) : super(props);
}

class TasksFetchEvent extends TasksEvent {
  /*
  bool finishedOnly = true;
  bool unfinishedOnly = false;

  bool expired = false;
  */


  TasksFetchEvent(/*{this.unfinishedOnly, this.expired}*/) :  super([/*unfinishedOnly*/]){

  }
  @override
  String toString() => 'TasksFetchEvent';
}
//endregion

//region SubjectItemListStates
abstract class TasksState extends HState {
  TasksState([List props = const []]) : super(props);
}

class TasksInitialState extends TasksState {
  @override
  String toString() => 'TasksInitialState';
}

class TasksWaitingState extends TasksState {
  @override
  String toString() => 'TasksWaitingState';
}



class TasksLoadedState extends TasksState {
  List<PojoTask> tasks;

  TasksLoadedState(this.tasks) : assert(tasks!= null), super([tasks]);
  @override
  String toString() => 'TasksLoadedState';
}

class TasksLoadedCacheState extends TasksState {
  List<PojoTask> data;

  TasksLoadedCacheState(this.data) : assert(data!= null), super([data]);
  @override
  String toString() => 'TasksLoadedCacheState';
}

class TasksErrorState extends TasksState {
  HazizzResponse hazizzResponse;
  TasksErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'TasksErrorState';
}


//endregion

//region SubjectItemListBloc
class TasksBloc extends Bloc<TasksEvent, TasksState> {

  TasksBloc(){

  }

  TaskCompleteState currentTaskCompleteState = TaskCompleteState.UNCOMPLETED;

  bool onlyExpired = false;
 // bool onlyIncomplete = true;

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  List<PojoTask> tasks;

  @override
  TasksState get initialState => TasksInitialState();

  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if (event is TasksFetchEvent) {
      try {
        yield TasksWaitingState();

        if(!onlyExpired && currentTaskCompleteState == TaskCompleteState.UNCOMPLETED){
          DataCache dataCache = await loadTasksCache();
          if(dataCache!= null){
            lastUpdated = dataCache.lastUpdated;
            tasks = dataCache.data;

            yield TasksLoadedCacheState(tasks);
          }
        }


        /*
        DateTime now = DateTime.now();

        int dayOfYear = int.parse(DateFormat("D").format(n ow));
        int weekOfYear = ((dayOfYear - now.weekday + 10) / 7).floor();

        print("WEEK OF YEAR: $weekOfYear");*/

        String startDate = null;
        String endDate = null;
        if(onlyExpired){
          DateTime now = DateTime.now();
          endDate = hazizzRequestDateFormat(now);
          startDate = hazizzRequestDateFormat(now.subtract(Duration(days: 365)));
        }

        bool unfinishedOnly = false;
        bool finishedOnly = false;

        if(currentTaskCompleteState == TaskCompleteState.UNCOMPLETED){
          unfinishedOnly = true;
          finishedOnly = false;
        }else if(currentTaskCompleteState == TaskCompleteState.COMPLETED){
          unfinishedOnly = false;
          finishedOnly = true;
        }if(currentTaskCompleteState == TaskCompleteState.BOTH){
          unfinishedOnly = false;
          finishedOnly = false;
        }

        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe(q_unfinishedOnly: unfinishedOnly, q_finishedOnly: finishedOnly, q_showThera: true, q_startingDate: startDate, q_endDate: endDate));

        //  print("tasks.: ${tasks}");
        if(hazizzResponse.isSuccessful){

          print("tasks.tasks: ${ hazizzResponse.convertedData}");
          tasks = hazizzResponse.convertedData;
          print("off: $tasks");
          if(tasks != null ){
            lastUpdated = DateTime.now();
            if(!onlyExpired && currentTaskCompleteState == TaskCompleteState.UNCOMPLETED) {
              saveTasksCache(tasks);
            }

            print("log: opsie: 0");

            // tasks = tasksDummy;


            print("log: opsie: 0");

            // TasksEventBloc.dispatch(TasksEventUpdateClassesEvent());

            yield TasksLoadedState(tasks);

            print("log: oy133");
          }


        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            print("log: noConnectionError22");
            yield TasksErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.dispatch(TasksFetchEvent());
            },
                "Tasks_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            print("log: noConnectionError22");
            this.dispatch(TasksFetchEvent());
          }else{
            yield TasksErrorState(hazizzResponse);

          }


        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }

}
//endregion
//endregion
