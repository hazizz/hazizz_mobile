
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
}



class TextFormLock extends HFormEvent {
  @override
  String toString() => 'TextFormLock';
}

class TextFormUnlock extends HFormEvent {
  @override
  String toString() => 'TextFormUnlock';
}

class TextFormSetEvent extends HFormEvent {
  final String text;

  TextFormSetEvent({
    @required this.text
  }) : super([text]);

  @override
  String toString() => 'TextFormSetEvent';
}

class TextFormClear extends HFormEvent {
  @override
  String toString() => 'TextFormClear';
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

class TextFormInitial extends HFormState {
  @override
  String toString() => 'TextFormInitial';
}

class TextFormFine extends HFormState {
  @override
  String toString() => 'TextFormFine';
}
class TextFormDontShow extends HFormState {
  @override
  String toString() => 'TextFormDontShow';
}



class TextFormLocked extends HFormState {
  @override
  String toString() => 'TextFormLocked';
}

class TextFormUnlocked extends HFormState {
  @override
  String toString() => 'TextFormUnlocked';
}

class TextFormSetState extends HFormState {
 final String text;

  TextFormSetState({
    @required this.text
  }) : super([text]);

  
  @override
  String toString() => 'TextFormSetState';
}

class TextFormCleared extends HFormState {
  @override
  String toString() => 'TextFormCleared';
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