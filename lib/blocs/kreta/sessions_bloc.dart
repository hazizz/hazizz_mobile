import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/managers/kreta_session_manager.dart';

//region Sessions event
abstract class SessionsEvent extends HEvent {
  SessionsEvent([List props = const []]) : super(props);
}

class SelectedSessionInactiveEvent extends SessionsEvent {
  @override
  String toString() => 'SelectedSessionInactiveEvent';
  List<Object> get props => null;
}
//endregion

//region Sessions bloc
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

  void checkSession(){
    if(sessions != null && sessions.isNotEmpty){
      if( !sessions.any((element) => element.username == SelectedSessionBloc().selectedSession.username)){
        SelectedSessionBloc().dispatch(SelectedSessionSetEvent(sessions[0]));
      }
    }
  }

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      // TODO check currentSession is here
      yield ResponseWaiting();
      sessions = getActiveSessions(await KretaSessionManager.getSessions());

      checkSession();

      activeSessions = getActiveSessions(sessions);
      yield ResponseDataLoadedFromCache(data: sessions);

      HazizzResponse hazizzResponse = await getResponse(new KretaGetSessions());
      print("KretaGetSessions request was sent!");
      if(hazizzResponse.isSuccessful){
        sessions = hazizzResponse.convertedData;
        checkSession();
        KretaSessionManager.setSessions(sessions);
        activeSessions = getActiveSessions(sessions);
        yield ResponseDataLoaded(data: sessions);
      }else{
        HazizzResponse hazizzResponse = await getResponse(new KretaGetSessions());
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
//endregion



