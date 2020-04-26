import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/managers/preference_services.dart';

//region Flush event and state parts
abstract class ShowFramerateEvent extends HEvent {
  ShowFramerateEvent([List props = const []]) : super(props);
}
abstract class ShowFramerateState extends HState {
  ShowFramerateState([List props = const []]) : super(props);
}


class ShowFramerateEnableEvent extends ShowFramerateEvent {
  @override String toString() => 'ShowFramerateEnableEvent';
  @override
  List<Object> get props => null;
}

class ShowFramerateDisableEvent extends ShowFramerateEvent {
  @override String toString() => 'ShowFramerateDisableEvent';
  @override
  List<Object> get props => null;
}

class ShowFramerateEnabledState extends ShowFramerateState {
  @override String toString() => 'ShowFramerateEnabledState';
  @override
  List<Object> get props => null;
}

class ShowFramerateDisabledState extends ShowFramerateState {
  @override String toString() => 'ShowFramerateDisabledState';
  @override
  List<Object> get props => null;
}
//endregion

//region Flush bloc
class ShowFramerateBloc extends Bloc<ShowFramerateEvent, ShowFramerateState> {

  ShowFramerateState get initialState => PreferenceService.enabledShowFramerate ?
  ShowFramerateEnabledState() :
  ShowFramerateDisabledState();

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<ShowFramerateState> mapEventToState(ShowFramerateEvent event) async* {
    print("dude1: ${event.toString()}");
    if (event is ShowFramerateEnableEvent) {
      yield ShowFramerateEnabledState();
    }else if (event is ShowFramerateDisableEvent) {
      yield ShowFramerateDisabledState();
    }
  }
}
//endregion