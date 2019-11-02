import 'dart:math';

import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:bloc/bloc.dart';
abstract class FlushEvent extends HEvent {
  FlushEvent([List props = const []]) : super(props);
}
abstract class FlushState extends HState {
  FlushState([List props = const []]) : super(props);
}

class FlushNoConnectionEvent extends FlushEvent {
  @override String toString() => 'FlushNoConnectionEvent';
  @override
  List<Object> get props => null;
}
class FlushNoConnectionState extends FlushState {
  @override String toString() => 'FlushNoConnectionState';
  @override
  List<Object> get props => null;
}


class FlushKretaUnavailableEvent extends FlushEvent {
  @override String toString() => 'FlushKretaUnavailableEvent';
  @override
  List<Object> get props => null;
}
class FlushKretaUnavailableState extends FlushState {
  @override String toString() => 'FlushKretaUnavailableState';
  @override
  List<Object> get props => null;
}

class FlushInitialEvent extends FlushEvent {
  @override String toString() => 'FlushInitialEvent';
  @override
  List<Object> get props => null;
}
class FlushInitialState extends FlushState {
  @override String toString() => 'FlushInitialState';
  @override
  List<Object> get props => null;
}

FlushBloc flushBloc = FlushBloc();

class FlushBloc extends Bloc<FlushEvent, FlushState> {

  static final FlushBloc _singleton = new FlushBloc._internal();
  factory FlushBloc() {
    return _singleton;
  }
  FlushBloc._internal();

  FlushState get initialState => FlushInitialState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Stream<FlushState> mapEventToState(FlushEvent event) async* {
    print("dude1: ${event.toString()}");
    if (event is FlushNoConnectionEvent) {
      yield FlushNoConnectionState();
    }else if (event is FlushKretaUnavailableEvent) {
      yield FlushKretaUnavailableState();
    }else if (event is FlushInitialEvent) {
      yield FlushInitialState();
    }

    print("dude2: ${currentState.toString()}");
  }
}