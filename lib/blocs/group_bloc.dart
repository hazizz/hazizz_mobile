import 'package:bloc/bloc.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';
import 'package:hazizz_mobile/communication/pojos/PojoUser.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';

import 'package:meta/meta.dart';

import '../RequestSender.dart';

/*
class FetchGroupTasksData extends HEvent {
  final int groupId;
  FetchGroupTasksData({this.groupId})
      : assert(groupId != null), super([groupId]);
  @override
  String toString() => 'PickedSubjectState';
}
*/

class GroupTasksBloc extends Bloc<HEvent, HState> {
  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        dynamic responseData = await RequestSender().getResponse(new GetTasksFromGroup(groupId: GroupBlocs.groupId));
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

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        dynamic responseData = await RequestSender().getResponse(new GetSubjects(groupId: GroupBlocs.groupId));

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

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        dynamic responseData = await RequestSender().getResponse(new GetGroupMembers(groupId: GroupBlocs.groupId));

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
  static int groupId;
  GroupTasksBloc groupTasksBloc = new GroupTasksBloc();
  GroupSubjectsBloc groupSubjectsBloc = new GroupSubjectsBloc();
  GroupMembersBloc groupMembersBloc = new GroupMembersBloc();

  GroupBlocs({int groupId_}){
    groupId = groupId_;
  }
}







