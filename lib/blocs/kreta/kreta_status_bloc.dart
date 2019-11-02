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
  List<Object> get props => null;
}

class KretaStatusAvailableEvent extends KretaStatusEvent {
  @override
  String toString() => 'KretaStatusAvailableEvent';
  List<Object> get props => null;
}



class KretaStatusInitalizeEvent extends KretaStatusEvent {
  @override
  String toString() => 'KretaStatusInitalizeEvent';
  List<Object> get props => null;
}
//endregion

//region SubjectItemListStates
abstract class KretaStatusState extends HState {
  KretaStatusState([List props = const []]) : super(props);
}

class KretaStatusInitialState extends KretaStatusState {
  @override
  String toString() => 'KretaStatusInitialState';
  List<Object> get props => null;
}

class KretaStatusAvailableState extends KretaStatusState {
  String toString() => 'KretaStatusAvailableState';
  List<Object> get props => null;
}

class KretaStatusUnavailableState extends KretaStatusState {
  @override
  String toString() => 'KretaStatusUnavailableState';
  List<Object> get props => null;
}

class KretaStatusWaiting extends KretaStatusState {
  @override
  String toString() => 'KretaStatusWaiting';
  List<Object> get props => null;
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
