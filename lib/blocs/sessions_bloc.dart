import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';


import '../request_sender.dart';
import '../hazizz_response.dart';

class SessionsBloc extends Bloc<HEvent, HState> {

  static final SessionsBloc _singleton = new SessionsBloc._internal();
  factory SessionsBloc() {
    return _singleton;
  }
  SessionsBloc._internal();

  @override
  HState get initialState => ResponseEmpty();

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      try {
        yield ResponseWaiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetSessions());

        if(hazizzResponse.isSuccessful){
          List<PojoSession> sessions = hazizzResponse.convertedData;
          yield ResponseDataLoaded(data: sessions);

        }
        if(hazizzResponse.isError){
          yield ResponseError(errorResponse: hazizzResponse);
        }
      } on Exception catch(e){
        print("log: Exception: ${e.toString()}");
      }
    }
  }
}

/*
class GroupBlocs{
  // static int groupId = 0;
  PojoGroup group;
  SessionsBloc SessionsBloc = new SessionsBloc();
  GroupSubjectsBloc groupSubjectsBloc = new GroupSubjectsBloc();
  GroupMembersBloc groupMembersBloc = new GroupMembersBloc();

  static final GroupBlocs _singleton = new GroupBlocs._internal();
  factory GroupBlocs() {
    return _singleton;
  }
  GroupBlocs._internal();

  void newGroup(PojoGroup group){
    this.group = group;
    SessionsBloc.dispatch(FetchData());
    groupSubjectsBloc.dispatch(FetchData());
    groupMembersBloc.dispatch(FetchData());
  }

}
*/






