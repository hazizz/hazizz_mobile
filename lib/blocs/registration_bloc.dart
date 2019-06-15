import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/communication/errorcode_collection.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import '../RequestSender.dart';
import 'TextFormBloc.dart';
import 'package:hazizz_mobile/exceptions/exceptions.dart';


//region Registration events
abstract class RegistrationEvent extends HEvent {
  RegistrationEvent([List props = const []]) : super(props);
}

class RegisterButtonPressed extends RegistrationEvent {
  final String username;
  final String email;
  final String password;

  RegisterButtonPressed({
    @required this.username,
    @required this.email,
    @required this.password,
  }) : super([username, email, password]);

  @override
  String toString() =>
      'RegisterButtonPressed { username: $username, password: $password }';
}
//endregion

//region Registration states
abstract class RegistrationState extends HState {
  RegistrationState([List props = const []]) : super(props);
}

class RegisterInitial extends RegistrationState {
  @override
  String toString() => 'RegisterInitial';
}

class RegisterLoading extends RegistrationState {
  @override
  String toString() => 'RegisterLoading';
}

class RegisterSuccessState extends RegistrationState {

  @override
  String toString() => 'RegisterSuccessState';
}


//endregion

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final TextFormBloc usernameBloc;
  final TextFormBloc passwordBloc;

  RegistrationBloc(this.usernameBloc, this.passwordBloc);

  RegistrationState get initialState => RegisterInitial();


  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegisterButtonPressed) {
      print("sentaa1");

      usernameBloc.dispatch(TextFormValidate(text: event.username));
      passwordBloc.dispatch(TextFormValidate(text: event.password));

      HFormState usernameState = usernameBloc.currentState;
      HFormState passwordState = passwordBloc.currentState;
      print("log: usernameState: ${usernameState.toString()}");
      print("log: usernameState: ${usernameState.toString()}");

      if(usernameState is TextFormFine) {
        if(passwordState is TextFormFine) { //usernameState is TextFormFine && passwordState is TextFormFine) {
          try {
            print("sentaa22");
            Response response = await RequestSender().getResponse(
                new RegisterUser(
                    b_username: event.username,
                    b_emailAddress: event.email,
                    b_password: event.password
            ));
            if(response.statusCode == 201){
              yield RegisterSuccessState();
            }else{
              print("log: not successful registration!");
            }
          }on HResponseError catch(e) {
            print("piritos111");
            int errorCode = e.error.errorCode;
            if(ErrorCodes.USERNAME_CONFLICT.equals(errorCode)) {
              print("piritos222");
              usernameBloc.dispatch(TextFormUsernameTakenEvent());
            }
          }
        }
      }
    }
  }
}

//region TextForm events
class TextFormUsernameTakenEvent extends HFormEvent {
  @override
  String toString() => 'TextFormUsernameTakenEvent';
}
//endregion

//region TextForm states
class TextFormUsernameTakenState extends HFormState {
  @override
  String toString() => 'TextFormUsernameTakenState';
}
class TextFormEmailInvalidState extends HFormState {
  @override
  String toString() => 'TextFormEmailInvalid';
}
//endregion

class RegistrationPageBlocs{
  TextFormBloc usernameBloc = new TextFormBloc(
      validate: (String text){
        if(text.length < 4){
          print("TextFormErrorTooShort");
          return TextFormErrorTooShort();
        }if(text.length >= 20){
          return TextFormErrorTooLong();
        }
        return TextFormFine();

      },
      handleErrorEvents: (HFormEvent event){
        if(event is TextFormUsernameTakenEvent){
          return TextFormUsernameTakenState();
        }
      }
  );
  TextFormBloc emailBloc = new TextFormBloc(
      validate: (String text){
        final String emailRegex = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(emailRegex);
        if(!regExp.hasMatch(text)) {
          return TextFormEmailInvalidState();
        }
        return TextFormFine();
      }
  );
  TextFormBloc passwordBloc = new TextFormBloc(
      validate: (String text){
        if(text.length < 8) {
          return TextFormErrorTooShort();
        }
        return TextFormFine();
      },
      handleErrorEvents: (HFormEvent event){
        /*if(event is PasswordIncorrectEvent){
          return PasswordIncorrectState();
        }
        */
      }
  );

  RegistrationBloc registrationBloc;

  RegistrationPageBlocs(){
    registrationBloc = new RegistrationBloc(usernameBloc, passwordBloc);
  }
}