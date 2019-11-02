
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
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
  @override
  List<Object> get props => [text];
}



class TextFormLock extends HFormEvent {
  @override
  String toString() => 'TextFormLock';
  @override
  List<Object> get props => null;
}

class TextFormUnlock extends HFormEvent {
  @override
  String toString() => 'TextFormUnlock';
  @override
  List<Object> get props => null;
}

class TextFormSetEvent extends HFormEvent {
  final String text;

  TextFormSetEvent({
    @required this.text
  }) : super([text]);

  @override
  String toString() => 'TextFormSetEvent';
  @override
  List<Object> get props => [text];
}

class TextFormClear extends HFormEvent {
  @override
  String toString() => 'TextFormClear';
  @override
  List<Object> get props => null;
}




class TextFormIllegalCharacterEvent extends HFormEvent {
  @override
  String toString() => 'TextFormIllegalCharacterEvent';
  @override
  List<Object> get props => null;
}
//endregion

//region TextForm states
abstract class HFormState extends HState {
  HFormState([List props = const []]) : super(props);
}

class TextFormInitial extends HFormState {
  @override
  String toString() => 'TextFormInitial';
  List<Object> get props => null;
}

class TextFormFine extends HFormState {
  @override
  String toString() => 'TextFormFine';
  List<Object> get props => null;
}
class TextFormDontShow extends HFormState {
  @override
  String toString() => 'TextFormDontShow';
  List<Object> get props => null;

}



class TextFormLocked extends HFormState {
  @override
  String toString() => 'TextFormLocked';
  List<Object> get props => null;
}

class TextFormUnlocked extends HFormState {
  @override
  String toString() => 'TextFormUnlocked';
  List<Object> get props => null;
}

class TextFormSetState extends HFormState {
 final String text;

  TextFormSetState({
    @required this.text
  }) : super([text]);

  
  @override
  String toString() => 'TextFormSetState';
 List<Object> get props => [text];
}

class TextFormCleared extends HFormState {
  @override
  String toString() => 'TextFormCleared';
  List<Object> get props => null;
}




class TextFormEmpty extends HFormState {
  @override
  String toString() => 'TextFormDontShow';
  List<Object> get props => null;
}

class TextFormErrorTooLong extends HFormState {
  @override
  String toString() => 'TextFormErrorTooLong';
  List<Object> get props => null;
}
class TextFormErrorTooShort extends HFormState {
  @override
  String toString() => 'TextFormErrorTooShort';
  List<Object> get props => null;
}

class TextFormIllegalCharacterState extends HFormState {
  @override
  String toString() => 'TextFormIllegalCharacterEvent';
  List<Object> get props => null;
}
//endregion

class TextFormBloc extends Bloc<HFormEvent, HFormState> {

  bool isLocked = false;

  String lastText = null;

  HFormState Function(String text) validate;

  HFormState Function(HFormEvent event) handleErrorEvents;

  TextFormBloc({this.validate, this.handleErrorEvents}){
    if(validate == null){
      validate = (String text){return TextFormFine();};
    }
    if(handleErrorEvents == null){
      handleErrorEvents = (HFormEvent event){return TextFormFine();};
    }

  }

  HFormState get initialState => TextFormInitial();

  @override
  Stream<HFormState> mapEventToState(HFormEvent event) async* {
 /*   HazizzLogger.printLog("state change: $event");
    HazizzLogger.printLog("isLocked: $isLocked");
    HazizzLogger.printLog("lastText: $lastText, ");
*/

    Exception("asd");
    if(event is TextFormLock){
      isLocked = true;
      yield TextFormLocked();
    }else if(event is TextFormUnlock){
      isLocked = false;
      yield TextFormUnlocked();
    }


    else if(event is TextFormSetEvent) {
      lastText = event.text;
    //  HazizzLogger.printLog("title is set: $lastText");
      yield TextFormSetState(text: event.text);
    }


    else if(!isLocked){
      if (event is TextFormValidate) {
        if(lastText != event.text || lastText == null){
         // HazizzLogger.printLog("VALIDITATION: ${event.text}: ${validate(event.text)}");
          yield validate(event.text);
       //   HazizzLogger.printLog("ajksiofdcoji: ${currentState}");
          lastText = event.text;
        }
      }else if(event is TextFormIllegalCharacterEvent){
        yield TextFormIllegalCharacterState();
      }
      else {
     //   HazizzLogger.printLog("piritos333");
        yield handleErrorEvents(event);
      }
    }
  }
}