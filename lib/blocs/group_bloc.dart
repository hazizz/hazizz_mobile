import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';


import '../RequestSender.dart';

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
        dynamic responseData = await RequestSender().getResponse(new GetTasksFromGroup(groupId: GroupBlocs().group.id));
        print("log: responseData: ${responseData}");

        if(responseData is List<PojoTask>){
          List<PojoTask> tasks = responseData;
          if(tasks.isNotEmpty) {
            yield ResponseDataLoaded(data: responseData);
          }else{
            yield ResponseEmpty();
          }
        }
        if(responseData is PojoError){
          yield ResponseError(error: responseData);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}

class GroupSubjectsBloc extends Bloc<HEvent, HState> {
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
        dynamic responseData = await RequestSender().getResponse(new GetSubjects(groupId: GroupBlocs().group.id));

        if(responseData is List<PojoSubject>){
          List<PojoSubject> tasks = responseData;
          if(tasks.isNotEmpty) {
            yield ResponseDataLoaded(data: responseData);
          }else{
            yield ResponseEmpty();
          }
        }
        if(responseData is PojoError){
          yield ResponseError(error: responseData);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}

class GroupMembersBloc extends Bloc<HEvent, HState> {
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
        dynamic responseData = await RequestSender().getResponse(new GetGroupMembers(groupId: GroupBlocs().group.id));

        if(responseData is List<PojoUser>){
          List<PojoUser> tasks = responseData;
          if(tasks.isNotEmpty) {
            yield ResponseDataLoaded(data: responseData);
          }else{
            yield ResponseEmpty();
          }
        }
        if(responseData is PojoError){
          yield ResponseError(error: responseData);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}

class GroupBlocs{
 // static int groupId = 0;
  PojoGroup group;
  GroupTasksBloc groupTasksBloc = new GroupTasksBloc();
  GroupSubjectsBloc groupSubjectsBloc = new GroupSubjectsBloc();
  GroupMembersBloc groupMembersBloc = new GroupMembersBloc();

  static final GroupBlocs _singleton = new GroupBlocs._internal();
  factory GroupBlocs() {
    return _singleton;
  }
  GroupBlocs._internal();

  void newGroup(PojoGroup group){
    this.group = group;
    groupTasksBloc.dispatch(FetchData());
    groupSubjectsBloc.dispatch(FetchData());
    groupMembersBloc.dispatch(FetchData());
  }

}







