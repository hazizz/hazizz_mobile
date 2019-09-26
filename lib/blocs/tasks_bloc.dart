import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/task_complete_state_enum.dart';
import 'package:mobile/enums/task_expired_state_enum.dart';


import '../caches/data_cache.dart';
import '../communication/connection.dart';
import '../communication/errors.dart';
import '../communication/requests/request_collection.dart';
import '../hazizz_date.dart';
import '../hazizz_response.dart';
import '../request_sender.dart';

//region EditTask bloc parts
//region EditTask events
abstract class TasksEvent extends HEvent {
  TasksEvent([List props = const []]) : super(props);
}

class TasksFetchEvent extends TasksEvent {

  TasksFetchEvent(/*{this.unfinishedOnly, this.expired}*/) :  super([/*unfinishedOnly*/]){

  }
  @override
  String toString() => 'TasksFetchEvent';
}

class TasksRemoveItemEvent extends TasksEvent {

  DateTime mapKey;
  int index;

  TasksRemoveItemEvent({this.mapKey, this.index}) :  super([DateTime.now().microsecondsSinceEpoch]){

  }
  @override
  String toString() => 'TasksRemoveItemEvent';
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
  Map<DateTime, List<PojoTask>> tasks;

  TasksLoadedState(this.tasks) : assert(tasks!= null), super([tasks, DateTime.now()]);
  @override
  String toString() => 'TasksLoadedState';
}

class TasksLoadedCacheState extends TasksState {
  Map<DateTime, List<PojoTask>> tasks;

  TasksLoadedCacheState(this.tasks) : assert(tasks!= null), super([tasks]);
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

  bool wholeGroup = false;
  int groupId = null;

  TasksBloc(){

  }

  TasksBloc.group(int groupId){
    wholeGroup = true;
    this.groupId = groupId;
  }

  TaskCompleteState currentTaskCompleteState = TaskCompleteState.UNCOMPLETED;

  TaskExpiredState currentTaskExpiredState = TaskExpiredState.UNEXPIRED;

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
  TasksState get initialState => TasksInitialState();


  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if(event is TasksRemoveItemEvent){

      debugPrint("yolo: ${tasks}");
      tasks[event.mapKey].removeAt(event.index);

      if(tasks[event.mapKey].isEmpty){
        HazizzLogger.printLog("is realy empty");
        tasks.remove(event.mapKey);
      }

      yield TasksLoadedState(tasks);
    }
    if (event is TasksFetchEvent) {
      try {
        yield TasksWaitingState();

        if(currentTaskExpiredState == TaskExpiredState.UNEXPIRED
        && currentTaskCompleteState == TaskCompleteState.UNCOMPLETED
        && groupId == null){
          DataCache dataCache = await loadTasksCache();
          if(dataCache!= null){
            lastUpdated = dataCache.lastUpdated;
            tasksRaw = dataCache.data;
            onLoaded(tasksRaw);
            yield TasksLoadedCacheState(tasks);
          }
        }

        String startDate = null;
        String endDate = null;
        if(currentTaskExpiredState == TaskExpiredState.EXPIRED){
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

       // HazizzResponse hazizzResponse2 = await RequestSender().getResponse(new GetRecentEvents());


        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe(q_unfinishedOnly: unfinishedOnly, q_finishedOnly: finishedOnly, q_showThera: true, q_startingDate: startDate, q_endDate: endDate, q_groupId: groupId, q_wholeGroup: wholeGroup));

        //  HazizzLogger.printLog("tasks.: ${tasks}");
        if(hazizzResponse.isSuccessful){

          HazizzLogger.printLog("tasks.tasks: ${ hazizzResponse.convertedData}");
          tasksRaw = hazizzResponse.convertedData;
          HazizzLogger.printLog("off: $tasksRaw");
          if(tasksRaw != null ){
            onLoaded(tasksRaw);

            lastUpdated = DateTime.now();
            if(currentTaskExpiredState == TaskExpiredState.UNEXPIRED
            && currentTaskCompleteState == TaskCompleteState.UNCOMPLETED
            && groupId == null) {
              saveTasksCache(tasksRaw);
            }

            HazizzLogger.printLog("log: opsie: 0");

            // tasks = tasksDummy;


            HazizzLogger.printLog("log: opsie: 0");

            yield TasksLoadedState(tasks);

            HazizzLogger.printLog("log: oy133");
          }
        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            HazizzLogger.printLog("log: noConnectionError22");
            yield TasksErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.dispatch(TasksFetchEvent());
            },
                "Tasks_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            HazizzLogger.printLog("log: noConnectionError22");
            this.dispatch(TasksFetchEvent());
          }else{
            yield TasksErrorState(hazizzResponse);

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










