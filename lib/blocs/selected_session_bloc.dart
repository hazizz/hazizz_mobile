import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';

import 'package:mobile/managers/kreta_session_manager.dart';

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
      print("asd debug22");

      PojoSession selectedSessionCached = await KretaSessionManager.getSelectedSession();
      print("asd debug33: $selectedSessionCached");

      if(selectedSessionCached != null){
        selectedSession = selectedSessionCached;
        yield SelectedSessionFineState(selectedSession);
      }else{
        yield SelectedSessionEmptyState();
      }
    }else if(event is SelectedSessionSetEvent){
      selectedSession = event.session;
      KretaSessionManager.setSelectedSession(selectedSession);
      yield SelectedSessionFineState(selectedSession);
    }
    else if (event is SelectedSessionInactiveEvent) {
      yield SelectedSessionInactiveState();
    }
  }

  @override
  SelectedSessionState get initialState => SelectedSessionInitialState();


}
//endregion
//endregion
