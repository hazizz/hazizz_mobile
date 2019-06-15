
import 'package:bloc/bloc.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:meta/meta.dart';

//region TextForm events
abstract class HFormEvent extends HEvent {
  HFormEvent([List props = const []]) : super(props);
}

class TextFormValidate extends HFormEvent {
  final String text;

  TextFormValidate({
    @required this.text
  }) : super([text]);

  @override
  String toString() =>
      'TextFormValidate: $text';
}

class TextFormIllegalCharacterEvent extends HFormEvent {
  @override
  String toString() => 'TextFormIllegalCharacterEvent';
}
//endregion

//region TextForm states
abstract class HFormState extends HState {
  HFormState([List props = const []]) : super(props);
}

class TextFormFine extends HFormState {
  @override
  String toString() => 'TextFormFine';
}
class TextFormDontShow extends HFormState {
  @override
  String toString() => 'TextFormDontShow';
}

class TextFormEmpty extends HFormState {
  @override
  String toString() => 'TextFormDontShow';
}

class TextFormErrorTooLong extends HFormState {
  @override
  String toString() => 'TextFormErrorTooLong';
}
class TextFormErrorTooShort extends HFormState {
  @override
  String toString() => 'TextFormErrorTooShort';
}

class TextFormIllegalCharacterState extends HFormState {
  @override
  String toString() => 'TextFormIllegalCharacterEvent';
}
//endregion

class TextFormBloc extends Bloc<HFormEvent, HFormState> {

  String lastText = null;

  final HFormState Function(String text) validate;

  final HFormState Function(HFormEvent event) handleErrorEvents;

  TextFormBloc({@required this.validate, this.handleErrorEvents});

  HFormState get initialState => TextFormFine();

  @override
  Stream<HFormState> mapEventToState(HFormEvent event) async* {
    print("state change");

    if (event is TextFormValidate) {
      if(lastText != event.text){
        yield validate(event.text);
        lastText = event.text;
      }
    }else if(event is TextFormIllegalCharacterEvent){
      yield TextFormIllegalCharacterState();
    }
    else {
      print("piritos333");
      yield handleErrorEvents(event);
    }
  }
}