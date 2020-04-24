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
    print("bruh moment XD 9");

    if(sessions != null && sessions.isNotEmpty){
      print("bruh moment XD 10");

      bool found = false;
      for(int i = 0; i < sessions.length; i++){
        PojoSession session = sessions[i];
        if(session.username == SelectedSessionBloc()?.selectedSession?.username){
          found = false;
        }
      }
      if(!found){
        print("bruh moment XD 11");

        SelectedSessionBloc().add(SelectedSessionSetEvent(sessions[0]));
      }

      /*
      if( !sessions.any((element) => element.username == SelectedSessionBloc().selectedSession.username)){
        print("bruh moment XD 11");

        SelectedSessionBloc().add(SelectedSessionSetEvent(sessions[0]));
      }
      */
    }
    print("bruh moment XD 12");
  }

  void removeDuplicate(){
    final List<String> reserved = [];

    final List<PojoSession> newSessions = sessions;

    print("removing dups: 0");

    for(int i = 0; i < sessions.length; i++){
      PojoSession session = sessions[i];
      print("removing dups: 0.1");

      if(reserved.contains(session.username)){
        print("removing dups: 1");

        newSessions.removeAt(i);
      }else{
        reserved.add(session.username);
      }
    }

    print("removing dups: 2");


    sessions = newSessions;
  }


  void prepareSessions(){
    removeDuplicate();
    checkSession();
  }

  @override
  Stream<HState> mapEventToState(HEvent event) async* {
    if (event is FetchData) {
      // TODO check currentSession is here
      print("bruh moment XD 1");
      yield ResponseWaiting();

      sessions = getActiveSessions(await KretaSessionManager.getCachedSessions());

      print("bruh moment XD 2: number of sessions that were cached:${activeSessions.length}");


      prepareSessions();
      print("bruh moment XD 3: number of sessions that are prepared:${sessions.length}");


      activeSessions = getActiveSessions(sessions);
      print("bruh moment XD 4: number of sessions that are active:${activeSessions.length}");

      yield ResponseDataLoadedFromCache(data: sessions);

      print("bruh moment XD 5");

      HazizzResponse hazizzResponse = await getResponse(new KretaGetSessions());
      print("KretaGetSessions request was sent!");
      if(hazizzResponse.isSuccessful){
        sessions = hazizzResponse.convertedData;
        prepareSessions();
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



