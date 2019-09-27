import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';

import 'package:mobile/managers/kreta_session_manager.dart';


//region EditTask bloc parts
//region EditTask events
abstract class KretaStatusEvent extends HEvent {
  KretaStatusEvent([List props = const []]) : super(props);
}

class KretaStatusUnavailableEvent extends KretaStatusEvent {
  @override
  String toString() => 'KretaStatusUnavailableEvent';
}

class KretaStatusAvailableEvent extends KretaStatusEvent {
  @override
  String toString() => 'KretaStatusAvailableEvent';
}



class KretaStatusInitalizeEvent extends KretaStatusEvent {
  @override
  String toString() => 'KretaStatusInitalizeEvent';
}
//endregion

//region SubjectItemListStates
abstract class KretaStatusState extends HState {
  KretaStatusState([List props = const []]) : super(props);
}

class KretaStatusInitialState extends KretaStatusState {
  @override
  String toString() => 'KretaStatusInitialState';
}

class KretaStatusAvailableState extends KretaStatusState {
  String toString() => 'KretaStatusAvailableState';
}

class KretaStatusUnavailableState extends KretaStatusState {
  @override
  String toString() => 'KretaStatusUnavailableState';
}

class KretaStatusWaiting extends KretaStatusState {
  @override
  String toString() => 'KretaStatusWaiting';
}

//endregion

//region SubjectItemListBloc
class KretaStatusBloc extends Bloc<KretaStatusEvent, KretaStatusState> {

  static final KretaStatusBloc _singleton = new KretaStatusBloc._internal();
  factory KretaStatusBloc() {
    return _singleton;
  }
  KretaStatusBloc._internal();

  @override
  Stream<KretaStatusState> mapEventToState(KretaStatusEvent event) async*{
    if(event is KretaStatusAvailableEvent){
      yield KretaStatusAvailableState();
    }
    else if(event is KretaStatusUnavailableEvent){
      yield KretaStatusUnavailableState();
    }
  }

  @override
  KretaStatusState get initialState => KretaStatusAvailableState();


}
//endregion
//endregion
