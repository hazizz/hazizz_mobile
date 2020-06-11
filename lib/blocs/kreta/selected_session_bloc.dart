import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/kreta/sessions_bloc.dart';
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

//region SelectedSession bloc parts
//region SelectedSession events
abstract class SelectedSessionEvent extends HEvent {
  SelectedSessionEvent([List props = const []]) : super(props);
}

class SelectedSessionInactiveEvent extends SelectedSessionEvent {
  @override
  String toString() => 'SelectedSessionInactiveEvent';
  List<Object> get props => null;
}
class SelectedSessionSetEvent extends SelectedSessionEvent {
  final PojoSession session;

  SelectedSessionSetEvent(this.session) : assert(session!= null), super([session]);
  @override
  String toString() => 'SelectedSessionSetEvent';
  List<Object> get props => [session];
}

class SelectedSessionInitalizeEvent extends SelectedSessionEvent {
  @override
  String toString() => 'SelectedSessionInitalizeEvent';
  List<Object> get props => null;
}
//endregion

//region SelectedSession states
abstract class SelectedSessionState extends HState {
  SelectedSessionState([List props = const []]) : super(props);
}

class SelectedSessionInitialState extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionInitialState';
  List<Object> get props => null;
}

class SelectedSessionEmptyState extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionEmptyState';
  List<Object> get props => null;
}

class SelectedSessionFineState extends SelectedSessionState {
  final PojoSession session;

  SelectedSessionFineState(this.session) : assert(session!= null), super([session]);
  @override
  String toString() => 'SelectedSessionFineState';
  List<Object> get props => [session];
}

class SelectedSessionInactiveState extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionSentState';
  List<Object> get props => null;
}

class SelectedSessionWaiting extends SelectedSessionState {
  @override
  String toString() => 'SelectedSessionWaiting';
  List<Object> get props => null;
}

//endregion

//region SelectedSession bloc
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

      if(selectedSessionCached != null){
        selectedSession = selectedSessionCached;
        yield SelectedSessionFineState(selectedSession);
        HazizzLogger.printLog("asd debug33: ${selectedSession.username}");
      }else{
        yield SelectedSessionEmptyState();
      }

      if(selectedSession == null){
        StreamSubscription sub;
        sub = SessionsBloc().listen((state){
          if(state is ResponseDataLoaded){
            print("haz: ${state.data}");
            if(state.data != null && state.data.isNotEmpty && state.data[0] != null){
              add(SelectedSessionSetEvent(state.data[0]));
              sub.cancel();
            }
          }
        });
      }
    }else if(event is SelectedSessionSetEvent){
      if(event.session.status == "ACTIVE"){
        selectedSession = event.session;
        KretaSessionManager.setSelectedSession(selectedSession);
        // MainTabBlocs().schedulesBloc.add(ScheduleFetchEvent());
        // MainTabBlocs().gradesBloc.add(GradesFetchEvent());
        yield SelectedSessionFineState(selectedSession);
        MainTabBlocs().schedulesBloc.add(ScheduleSetSessionEvent(dateTime: DateTime.now()));
        MainTabBlocs().gradesBloc.add(GradesSetSessionEvent());
      }
    }
    else if (event is SelectedSessionInactiveEvent) {
      if(await KretaSessionManager.isRememberPassword()){
        HazizzLogger.printLog("SelectedSessionInactiveEvent but remembers password and logins again");
        HazizzResponse hazizzResponse = await RequestSender().getResponse(
          KretaAuthenticateSession(
            pSession: selectedSession.id,
            bPassword: selectedSession.password
          )
        );
        if(hazizzResponse.isSuccessful){
          PojoSession newSession = hazizzResponse.convertedData;
          newSession.password = selectedSession.password;
          selectedSession = newSession;
          KretaSessionManager.selectedSession = selectedSession;
          await KretaSessionManager.setSelectedSession(selectedSession);

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

  void closeBloc(){
    _singleton.close();
  }
}
//endregion
//endregion
