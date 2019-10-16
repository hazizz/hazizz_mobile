import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/kreta/schedule_bloc.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';

import 'package:mobile/managers/kreta_session_manager.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/blocs/kreta/grades_bloc.dart';

//region EditTask bloc parts
//region EditTask events
abstract class SelectedSessionEvent extends HEvent {
  SelectedSessionEvent([List props = const []]) : super(props);
}

class SelectedSessionInactiveEvent extends SelectedSessionEvent {
  @override
  String toString() => 'SelectedSessionInactiveEvent';
}
class SelectedSessionSetEvent extends SelectedSessionEvent {
  PojoSession session;

  SelectedSessionSetEvent(this.session) : assert(session!= null), super([session]);
  @override
  String toString() => 'SelectedSessionSetEvent';
}

class SelectedSessionInitalizeEvent extends SelectedSessionEvent {
  @override
  String toString() => 'SelectedSessionInitalizeEvent';
}
//endregion

//region SubjectItemListStates
abstract class SelectedSessionState extends HState {
  SelectedSessionState([List props = const []]) : super(props);
}

class SelectedSessionInitialState extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionInitialState';
}

class SelectedSessionEmptyState extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionEmptyState';
}

class SelectedSessionFineState extends SelectedSessionState {
  PojoSession session;

  SelectedSessionFineState(this.session) : assert(session!= null), super([session]);
  @override
  String toString() => 'SelectedSessionFineState';
}

class SelectedSessionInactiveState extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionSentState';
}

class SelectedSessionWaiting extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionWaiting';
}

//endregion

//region SubjectItemListBloc
class SelectedSessionBloc extends Bloc<SelectedSessionEvent, SelectedSessionState> {

  PojoSession selectedSession;

  static final SelectedSessionBloc _singleton = new SelectedSessionBloc._internal();
  factory SelectedSessionBloc() {

    return _singleton;
  }
  SelectedSessionBloc._internal();

  @override
  Stream<SelectedSessionState> mapEventToState(SelectedSessionEvent event) async*{
    if(event is SelectedSessionInitalizeEvent){

      PojoSession selectedSessionCached = await KretaSessionManager.getSelectedSession();
      HazizzLogger.printLog("asd debug33: $selectedSessionCached");

      if(selectedSessionCached != null){
        selectedSession = selectedSessionCached;
        yield SelectedSessionFineState(selectedSession);
      }else{
        yield SelectedSessionEmptyState();
      }
    }else if(event is SelectedSessionSetEvent){
      selectedSession = event.session;
      await KretaSessionManager.setSelectedSession(selectedSession);
      MainTabBlocs().schedulesBloc.dispatch(ScheduleFetchEvent());
      MainTabBlocs().gradesBloc.dispatch(GradesFetchEvent());

      yield SelectedSessionFineState(selectedSession);
    }
    else if (event is SelectedSessionInactiveEvent) {
      if(await KretaSessionManager.isRememberPassword()){
        HazizzLogger.printLog("SelectedSessionInactiveEvent but remembers password and logins again");
        HazizzResponse hazizzResponse = await RequestSender().getResponse(KretaAuthenticateSession(p_session: selectedSession.id, b_password: selectedSession.password));
        if(hazizzResponse.isSuccessful){
          PojoSession newSession = hazizzResponse.convertedData;
          newSession.password = selectedSession.password;
          selectedSession = newSession;
          KretaSessionManager.selectedSession = selectedSession;
          yield SelectedSessionFineState(selectedSession);
        }else{
          yield SelectedSessionInactiveState();
        }


      }else{
        HazizzLogger.printLog("SelectedSessionInactiveEvent but doesnt remembers password");
        yield SelectedSessionInactiveState();
      }
    }
  }

  @override
  SelectedSessionState get initialState => SelectedSessionInitialState();


}
//endregion
//endregion
