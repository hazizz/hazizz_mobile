import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';


import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/managers/kreta_session_manager.dart';

abstract class SessionsEvent extends HEvent {
  SessionsEvent([List props = const []]) : super(props);
}

class SelectedSessionInactiveEvent extends SessionsEvent {
  @override
  String toString() => 'SelectedSessionInactiveEvent';
  List<Object> get props => null;
}

class SessionsBloc extends Bloc<HEvent, HState> {

  static final SessionsBloc _singleton = new SessionsBloc._internal();
  factory SessionsBloc() {
    return _singleton;
  }
  SessionsBloc._internal();

  @override
  HState get initialState => ResponseEmpty();

  List<PojoSession> activeSessions = [];
  List<PojoSession> sessions = [];

  List<PojoSession> getActiveSessions(List<PojoSession> allSessions){
    List<PojoSession> actS = [];
    for(PojoSession s in sessions){
      if(s.status == "ACTIVE"){
        actS.add(s);
      }
    }
    return actS;
  }

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      yield ResponseWaiting();
      sessions = getActiveSessions(await KretaSessionManager.getSessions());
      activeSessions = getActiveSessions(sessions);
      yield ResponseDataLoadedFromCache(data: sessions);

      HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetSessions());
      print("KretaGetSessions request was sent!");
      if(hazizzResponse.isSuccessful){
        sessions = hazizzResponse.convertedData;
        KretaSessionManager.setSessions(sessions);
        activeSessions = getActiveSessions(sessions);
        yield ResponseDataLoaded(data: sessions);
      }
      else{
        HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaGetSessions());
        print("KretaGetSessions request was sent2!");
        if(hazizzResponse.isSuccessful){
          sessions = hazizzResponse.convertedData;
          KretaSessionManager.setSessions(sessions);
          activeSessions = getActiveSessions(sessions);
          yield ResponseDataLoaded(data: sessions);
        }
        else{
          yield ResponseError(errorResponse: hazizzResponse);
        }
      }

    }
  }
}





