import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/tasks/tasks_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoGroupPermissions.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/group_permissions_enum.dart';
import 'package:mobile/storage/cache_manager.dart';


import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';

class GroupTasksBloc extends Bloc<HEvent, HState> {
  @override
  HState get initialState => ResponseEmpty();

  int get groupId{
    return GroupBlocs().group.id;
  }

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
       // HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromGroup(groupId: GroupBlocs().group.id));
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetTasksFromMe(q_groupId: GroupBlocs().group.id, q_wholeGroup: true));

        if(hazizzResponse.isSuccessful){
          List<PojoTask> tasks = hazizzResponse.convertedData;
          if(tasks.isNotEmpty) {
            yield ResponseDataLoaded(data: tasks);
          }else{
            yield ResponseEmpty();
          }
        }
        if(hazizzResponse.isError){
          yield ResponseError(errorResponse: hazizzResponse);
        }
      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }
}

class GroupSubjectsBloc extends Bloc<HEvent, HState> {
  @override
  HState get initialState => ResponseEmpty();

  int get groupId{
    HazizzLogger.printLog("groupId:: ${GroupBlocs().group.id}");
    return GroupBlocs().group.id;
  }

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetSubjects(groupId: GroupBlocs().group.id));

        if(hazizzResponse.isSuccessful){
          List<PojoSubject> tasks = hazizzResponse.convertedData;
          if(tasks.isNotEmpty) {
            yield ResponseDataLoaded(data: tasks);
          }else{
            yield ResponseEmpty();
          }
        }
        if(hazizzResponse.isError){
          yield ResponseError(errorResponse: hazizzResponse);
        }
      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }
}

class GroupMembersBloc extends Bloc<HEvent, HState> {
  PojoGroupPermissions membersPermissions;

  @override
  HState get initialState => ResponseEmpty();

  PojoGroup get group{
    return GroupBlocs().group;
  }

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new GetGroupMemberPermissions(groupId: GroupBlocs().group.id));

        if(hazizzResponse.isSuccessful){
          membersPermissions = hazizzResponse.convertedData;

          int myId = (await CacheManager.getMyUserData()).id;
          bool found = false;
          
          for(PojoUser member in membersPermissions.OWNER){
            if (myId == member.id){

              GroupBlocs().myPermissionBloc.dispatch(MyPermissionSetEvent(permission: GroupPermissionsEnum.OWNER));
              found = true;
            }
          }
          if(!found){
            for(PojoUser member in membersPermissions.MODERATOR){
              if (myId == member.id){
                GroupBlocs().myPermissionBloc.dispatch(MyPermissionSetEvent(permission: GroupPermissionsEnum.MODERATOR));
                found = true;
              }
            }
          }
          if(!found){
            for(PojoUser member in membersPermissions.USER){
              if (myId == member.id){
                GroupBlocs().myPermissionBloc.dispatch(MyPermissionSetEvent(permission: GroupPermissionsEnum.USER));
                found = true;
              }
            }
          }
          if(!found){
            for(PojoUser member in membersPermissions.NULL){
              if (myId == member.id){
                GroupBlocs().myPermissionBloc.dispatch(MyPermissionSetEvent(permission: GroupPermissionsEnum.NULL));
                found = true;
              }
            }
          }

          yield ResponseDataLoaded(data: membersPermissions);

        }
        if(hazizzResponse.hasPojoError){
          yield ResponseError(errorResponse: hazizzResponse);
        }
      } on Exception catch(e){
        HazizzLogger.printLog("log: Exception: ${e.toString()}");
      }
    }
  }
}



abstract class MyPermissionEvent extends HEvent {
  MyPermissionEvent([List props = const []]) : super(props);
}

abstract class MyPermissionState extends HState {
  MyPermissionState([List props = const []]) : super(props);
}

class MyPermissionSetEvent extends MyPermissionEvent {

  final GroupPermissionsEnum permission;

  MyPermissionSetEvent({
    @required this.permission,
  }) : super([permission]);

  @override String toString() => 'MyPermissionSetEvent';
  List<Object> get props => [permission];
}

class MyPermissionResetEvent extends MyPermissionEvent {

  @override String toString() => 'MyPermissionResetEvent';
  List<Object> get props => null;
}


class MyPermissionInitialState extends MyPermissionState {
  @override String toString() => 'MyPermissionInitialState';
  List<Object> get props => null;
}

class MyPermissionSetState extends MyPermissionState {

  final GroupPermissionsEnum permission;

  MyPermissionSetState({
    @required this.permission,
  }) : super([permission]);

  @override String toString() => 'MyPermissionSetState';
  List<Object> get props => [permission];
}


class MyPermissionBloc extends Bloc<MyPermissionEvent, MyPermissionState> {

  GroupPermissionsEnum myPermission;

  MyPermissionState get initialState => MyPermissionInitialState();

  void reset(){
    this.dispatch(MyPermissionResetEvent());
  }

  @override
  Stream<MyPermissionState> mapEventToState(MyPermissionEvent event) async* {

    if (event is MyPermissionSetEvent) {
      myPermission = event.permission;
      yield MyPermissionSetState( permission: event.permission);
    }else if (event is MyPermissionResetEvent) {
      myPermission = null;
      yield MyPermissionInitialState();
    }
  }
}

class GroupBlocs{
  MyPermissionBloc myPermissionBloc = MyPermissionBloc();

  PojoGroup group;
  TasksBloc groupTasksBloc;
  GroupSubjectsBloc groupSubjectsBloc = new GroupSubjectsBloc();
  GroupMembersBloc groupMembersBloc = new GroupMembersBloc();

  static final GroupBlocs _singleton = new GroupBlocs._internal();
  factory GroupBlocs() {
    return _singleton;
  }
  GroupBlocs._internal();

  void newGroup(PojoGroup group){
    this.group = group;
    groupTasksBloc = new TasksBloc.group(group.id);
    groupTasksBloc.dispatch(TasksFetchEvent());
    groupSubjectsBloc.dispatch(FetchData());
    groupMembersBloc.dispatch(FetchData());
  }

  void reset(){
    group = null;
    myPermissionBloc.dispatch(MyPermissionResetEvent());
  }
}







