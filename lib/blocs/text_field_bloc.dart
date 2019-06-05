import 'package:bloc/bloc.dart';
import 'package:flutter_hazizz/blocs/request_event.dart';
import 'package:flutter_hazizz/blocs/response_states.dart';

abstract class TextFieldState extends HState {
  TextFieldState([List props = const []]) : super(props);
}
class ErrorTooShortState extends TextFieldState {
  ErrorTooShortState() : super([]);
  @override
  String toString() => 'ErrorTooShort';
}
class ErrorTooLongState extends TextFieldState {
  ErrorTooLongState() : super([]);
  @override
  String toString() => 'ErrorTooLongState';
}


class FineState extends TextFieldState {
  FineState() : super([]);
  @override
  String toString() => 'Fine';
}

abstract class TextFieldEvent extends HEvent {
  TextFieldEvent([List props = const []]) : super(props);

  String get text => null;

}

class CheckEvent extends TextFieldEvent {
  final String text;
  CheckEvent({this.text})
      : assert(text != null), super([text]);
  @override
  String toString() => 'PickedEvent';
}
class SaveEvent extends TextFieldEvent {
  final String text;
  SaveEvent({this.text})
      : assert(text != null), super([text]);
  @override
  String toString() => 'SaveEvent';
}



class TextFieldBloc extends Bloc<TextFieldEvent, TextFieldState> {
  String text;
  
  @override
  TextFieldState get initialState => FineState();
  
  
  TextFieldState check(String text){
    
  }

  @override
  Stream<TextFieldState> mapEventToState(TextFieldEvent event) async* {
    if(event is CheckEvent || event is SaveEvent) {
      text = event.text;
      yield check(text);
    }
  }
}