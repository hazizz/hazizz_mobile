import 'package:bloc/bloc.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';

abstract class DateTimePickerState extends HState {
  DateTimePickerState([List props = const []]) : super(props);
}
class DateTimeNotPickedState extends DateTimePickerState {
  DateTimeNotPickedState() : super([]);
  @override
  String toString() => 'NotPicked';
}

class DateTimePickedState extends DateTimePickerState {
  final DateTime dateTime;
  DateTimePickedState({this.dateTime})
      : assert(dateTime != null), super([dateTime]);
  @override
  String toString() => 'PickedState';
}

abstract class DateTimePickerEvent extends HEvent {
  DateTimePickerEvent([List props = const []]) : super(props);
}

class DateTimePickedEvent extends DateTimePickerEvent {
  final DateTime dateTime;
  DateTimePickedEvent({this.dateTime})
      : assert(dateTime != null), super([dateTime]);
  @override
  String toString() => 'PickedEvent';
}

class DateTimeNotPickedEvent extends DateTimePickerEvent {
  @override
  String toString() => 'NotPickedEvent';
}


class DateTimePickerBloc extends Bloc<DateTimePickerEvent, DateTimePickerState> {
  @override
  DateTimePickerState get initialState => DateTimeNotPickedState();

  @override
  Stream<DateTimePickerState> mapEventToState(DateTimePickerEvent event) async* {
    if(event is DateTimePickedEvent){
      yield DateTimePickedState(dateTime: event.dateTime);
    }else if(event is DateTimeNotPickedEvent){
      yield DateTimeNotPickedState();
    }
  }
}