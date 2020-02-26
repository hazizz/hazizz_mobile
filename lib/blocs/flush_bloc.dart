import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:bloc/bloc.dart';

//region Flush event and state parts
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

class FlushServerUnavailableEvent extends FlushEvent {
  @override String toString() => 'FlushServerUnavailableEvent';
  @override
  List<Object> get props => null;
}
class FlushServerUnavailableState extends FlushState {
  @override String toString() => 'FlushServerUnavailableState';
  @override
  List<Object> get props => null;
}


class FlushGatewayServerUnavailableEvent extends FlushEvent {
  @override String toString() => 'FlushGatewayServerUnavailableEvent';
  @override
  List<Object> get props => null;
}
class FlushGatewayServerUnavailableState extends FlushState {
  @override String toString() => 'FlushGatewayServerUnavailableState';
  @override
  List<Object> get props => null;
}

class FlushAuthServerUnavailableEvent extends FlushEvent {
  @override String toString() => 'FlushAuthServerUnavailableEvent';
  @override
  List<Object> get props => null;
}
class FlushAuthServerUnavailableState extends FlushState {
  @override String toString() => 'FlushAuthServerUnavailableState';
  @override
  List<Object> get props => null;
}

class FlushHazizzServerUnavailableEvent extends FlushEvent {
  @override String toString() => 'FlushHazizzServerUnavailableEvent';
  @override
  List<Object> get props => null;
}
class FlushHazizzServerUnavailableState extends FlushState {
  @override String toString() => 'FlushHazizzServerUnavailableState';
  @override
  List<Object> get props => null;
}

class FlushTheraServerUnavailableEvent extends FlushEvent {
  @override String toString() => 'FlushTheraServerUnavailableEvent';
  @override
  List<Object> get props => null;
}
class FlushTheraServerUnavailableState extends FlushState {
  @override String toString() => 'FlushTheraServerUnavailableState';
  @override
  List<Object> get props => null;
}

class FlushSessionFailEvent extends FlushEvent {
  @override String toString() => 'FlushSessionFailEvent';
  @override
  List<Object> get props => null;
}
class FlushSessionFailState extends FlushState {
  @override String toString() => 'FlushSessionFailState';
  @override
  List<Object> get props => null;
}



class FlushResetState extends FlushState {
  @override String toString() => 'FlushResetState';
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
//endregion

//region Flush bloc
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
    }else if (event is FlushServerUnavailableEvent) {
      yield FlushServerUnavailableState();
    }

    else if (event is FlushGatewayServerUnavailableEvent) {
      yield FlushGatewayServerUnavailableState();
    }else if (event is FlushAuthServerUnavailableEvent) {
      yield FlushAuthServerUnavailableState();
    }else if (event is FlushHazizzServerUnavailableEvent) {
      yield FlushHazizzServerUnavailableState();
    }else if (event is FlushTheraServerUnavailableEvent) {
      yield FlushTheraServerUnavailableState();
    }

    else if (event is FlushKretaUnavailableEvent) {
      yield FlushKretaUnavailableState();
    }

    else if (event is FlushInitialEvent) {
      yield FlushInitialState();
    }
   /* else if (event is FlushSessionFailEvent) {
      yield FlushSessionFailState();
   //   yield FlushResetState();
    }
    */

    print("dude2: ${currentState.toString()}");
  }
}
//endregion