import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/task_complete_state_enum.dart';
import 'package:mobile/enums/task_expired_state_enum.dart';

import 'package:mobile/extension_methods/datetime_extension.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/managers/task_manager.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/data_cache.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

//region Tasks bloc parts
//region Tasks events
abstract class TasksEvent extends HEvent {
  TasksEvent([List props = const []]) : super(props);
}

class TasksFetchEvent extends TasksEvent {

  TasksFetchEvent() :  super();
  @override
  String toString() => 'TasksFetchEvent';
  List<Object> get props => null;
}

class TasksRemoveItemEvent extends TasksEvent {
  final DateTime mapKey;
  final int index;

  TasksRemoveItemEvent({this.mapKey, this.index}) :  super([DateTime.now().microsecondsSinceEpoch]);
  @override
  String toString() => 'TasksRemoveItemEvent';
  List<Object> get props => [mapKey, index, DateTime.now()];
}
//endregion

//region Tasks states
abstract class TasksState extends HState {
  TasksState([List props = const []]) : super(props);
}

class TasksInitialState extends TasksState {
  @override
  String toString() => 'TasksInitialState';
  List<Object> get props => null;
}

class TasksWaitingState extends TasksState {
  @override
  String toString() => 'TasksWaitingState';
  List<Object> get props => null;
}



class TasksLoadedState extends TasksState {
  final Map<DateTime, List<PojoTask>> tasks;

  TasksLoadedState(this.tasks) : assert(tasks!= null), super([tasks, DateTime.now()]);
  @override
  String toString() => 'TasksLoadedState';
  List<Object> get props => [tasks, DateTime.now()];
}

class TasksLoadedCacheState extends TasksState {
  final Map<DateTime, List<PojoTask>> tasks;

  TasksLoadedCacheState(this.tasks) : assert(tasks!= null), super([tasks]);
  @override
  String toString() => 'TasksLoadedCacheState';
  List<Object> get props => [tasks];
}

class TasksErrorState extends TasksState {
  final HazizzResponse hazizzResponse;
  TasksErrorState(this.hazizzResponse) : assert(hazizzResponse!= null), super([hazizzResponse]);

  @override
  String toString() => 'TasksErrorState';
  List<Object> get props => [hazizzResponse];
}


//endregion

//region Tasks bloc
class TasksBloc extends Bloc<TasksEvent, TasksState> {

  final bool wholeGroup;
  final int groupId;
  final bool theraEnabled;

  TasksBloc({this.theraEnabled = true})
    : wholeGroup = false, groupId = null;

  TasksBloc.group(int groupId, {this.theraEnabled = true})
    : wholeGroup = true, this.groupId = groupId;

  TaskCompleteStateEnum currentTaskCompleteState = TaskCompleteStateEnum.UNCOMPLETED;

  TaskExpiredStateEnum currentTaskExpiredState = TaskExpiredStateEnum.UNEXPIRED;

  DateTime lastUpdated = DateTime(0, 0, 0, 0, 0);

  List<PojoTask> tasksList;

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
    return null;
  }

  @override
  TasksState get initialState => TasksInitialState();


  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if(event is TasksRemoveItemEvent){

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

        if(currentTaskExpiredState == TaskExpiredStateEnum.UNEXPIRED
        && currentTaskCompleteState == TaskCompleteStateEnum.UNCOMPLETED
        && groupId == null){
          CacheData dataCache = await TaskManager.loadCache();
          if(dataCache!= null){
            lastUpdated = dataCache.lastUpdated;
            tasksList = dataCache.data;
            onLoaded(tasksList);
            yield TasksLoadedCacheState(tasks);
          }
        }

        String startDate;
        String endDate;
        if(currentTaskExpiredState == TaskExpiredStateEnum.EXPIRED){
          DateTime now = DateTime.now();
          endDate = now.hazizzRequestDateFormat;
          startDate = now.subtract(365.days).hazizzRequestDateFormat;
        }

        bool unfinishedOnly = false;
        bool finishedOnly = false;

        if(currentTaskCompleteState == TaskCompleteStateEnum.UNCOMPLETED){
          unfinishedOnly = true;
          finishedOnly = false;
        }else if(currentTaskCompleteState == TaskCompleteStateEnum.COMPLETED){
          unfinishedOnly = false;
          finishedOnly = true;
        }if(currentTaskCompleteState == TaskCompleteStateEnum.BOTH){
          unfinishedOnly = false;
          finishedOnly = false;
        }

        HazizzResponse hazizzResponse = await RequestSender().getResponse(
          GetTasksFromMe(qUnfinishedOnly: unfinishedOnly, qFinishedOnly: finishedOnly,
            qShowThera: theraEnabled, qStartingDate: startDate, qEndDate: endDate,
            qGroupId: groupId, qWholeGroup: wholeGroup
          )
        );

        if(hazizzResponse.isSuccessful){
          HazizzLogger.printLog("tasks.tasks: ${ hazizzResponse.convertedData}");
          tasksList = hazizzResponse.convertedData;
          HazizzLogger.printLog("off: $tasksList");
          if(tasksList != null ){
            onLoaded(tasksList);
            HazizzLogger.printLog("juhuhuuu: 1");
            lastUpdated = DateTime.now();
            if(currentTaskExpiredState == TaskExpiredStateEnum.UNEXPIRED
            && currentTaskCompleteState == TaskCompleteStateEnum.UNCOMPLETED
            && groupId == null) {
              TaskManager.saveCache(tasksList);
            }

            HazizzLogger.printLog("juhuhuuu: 2");

            HazizzLogger.printLog("log: opsie: 0");

            if(currentTaskExpiredState == TaskExpiredStateEnum.EXPIRED){
              Map<DateTime, List<PojoTask>> b = {};
              for(int i = tasks.keys.length-1; i >= 0; i--)
              {
                final DateTime key = tasks.keys.elementAt(i);
                b[key] = tasks[key];
              }
              tasks = b;

            }

            yield TasksLoadedState(tasks);

            HazizzLogger.printLog("log: oy133");
          }
        }
        else if(hazizzResponse.isError){

          if(hazizzResponse.dioError == noConnectionError){
            HazizzLogger.printLog("log: noConnectionError22");
            yield TasksErrorState(hazizzResponse);

            Connection.addConnectionOnlineListener((){
              this.add(TasksFetchEvent());
            },
                "Tasks_fetch"
            );

          }else if(hazizzResponse.dioError.type == DioErrorType.CONNECT_TIMEOUT
              || hazizzResponse.dioError.type == DioErrorType.RECEIVE_TIMEOUT) {
            HazizzLogger.printLog("log: noConnectionError22");
            this.add(TasksFetchEvent());
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










