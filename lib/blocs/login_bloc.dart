import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/notification/notification.dart';
import '../hazizz_response.dart';
import '../logger.dart';
import '../request_sender.dart';
import 'google_login_bloc.dart';
import 'TextFormBloc.dart';
import 'auth_bloc.dart';

import 'package:mobile/exceptions/exceptions.dart';

import 'main_tab_blocs/main_tab_blocs.dart';

import 'main_tab_blocs/main_tab_blocs.dart';

//region LoginEvents
abstract class LoginEvent extends HEvent {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
  }) : super([username, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}

class LoginButtonPressedTEST extends LoginEvent {

   final String username;
   final String password;

  LoginButtonPressedTEST({
    @required this.username,
    @required this.password,
  }) : super([username, password]);


  @override
  String toString() =>
      'LoginButtonPressed';
}
//endregion

//region LoginStates
abstract class LoginState extends HState {
  LoginState([List props = const []]) : super(props);
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginWaiting extends LoginState {
  @override
  String toString() => 'LoginWaiting';
}

class LoginStock extends LoginState {
  @override
  String toString() => 'LoginStock';
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class LoginFailPasswordWrong extends LoginState {

  LoginFailPasswordWrong();

  @override
  String toString() => 'LoginFailPasswordTooShort';
}
class LoginFailUsernameWrong extends LoginState {

  LoginFailUsernameWrong();

  @override
  String toString() => 'LoginFailUsernameWrong';
}

class LoginSuccessState extends LoginState {

  LoginSuccessState();

  @override
  String toString() => 'LoginSuccess';
}
//endregion

class BasicLoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authenticationBloc = AuthBloc();
  final TextFormBloc usernameBloc;
  final TextFormBloc passwordBloc;

  BasicLoginBloc(this.usernameBloc, this.passwordBloc);

  LoginState get initialState => LoginInitial();

  @override
  void dispose() {
    // TODO: implement dispose
    authenticationBloc.dispose();
    usernameBloc.dispose();
    passwordBloc.dispose();
    super.dispose();
  }


  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    HazizzLogger.printLog("sentaa state asd");

    if (event is LoginButtonPressedTEST) {
      HazizzLogger.printLog("sentaa1");

      usernameBloc.dispatch(TextFormValidate(text: event.username));
      passwordBloc.dispatch(TextFormValidate(text: event.password));

      HFormState usernameState = usernameBloc.currentState;
      HFormState passwordState = passwordBloc.currentState;
      HazizzLogger.printLog("log: usernameState: ${usernameState.toString()}");
      HazizzLogger.printLog("log: usernameState: ${usernameState.toString()}");

      if(usernameState is TextFormFine || usernameState is UserNotFoundState) {
        if(passwordState is TextFormFine) { //usernameState is TextFormFine && passwordState is TextFormFine) {
          try {

            HazizzResponse hazizzResponse = await RequestSender().getResponse(CreateToken.withPassword(q_username: event.username, q_password: event.password));
            if(hazizzResponse.isSuccessful){

              await AppState.logInProcedure(tokens: hazizzResponse.convertedData);


              authenticationBloc.dispatch(LoggedIn());
              yield LoginSuccessState();
            //  HazizzNotification.scheduleNotificationAlarmManager(await HazizzNotification.getNotificationTime());
            }

          }on HResponseError catch(e) {
            HazizzLogger.printLog("piritos111");
            int errorCode = e.error.errorCode;
            if(ErrorCodes.USER_NOT_FOUND.equals(errorCode)) {
              HazizzLogger.printLog("piritos222");
              usernameBloc.dispatch(UserNotFoundEvent());
            }else if(ErrorCodes.INVALID_PASSWORD.equals(errorCode)) {
              passwordBloc.dispatch(PasswordIncorrectEvent());
            }
          }
        }
      }

    }
  }
}







class UserNotFoundEvent extends HFormEvent {
  @override
  String toString() => 'UserNotFoundEvent';
}
class UserNotFoundState extends HFormState {
  @override
  String toString() => 'UserNotFoundState';
}


class PasswordIncorrectEvent extends HFormEvent {
  @override
  String toString() => 'PasswordIncorrectEvent';
}
class PasswordIncorrectState extends HFormState {
  @override
  String toString() => 'PasswordIncorrectState';
}


class LoginWidgetBlocs{

  Function onLogInSuccessful;

  dispose(){
    passwordBloc.dispose();
    usernameBloc.dispose();
    basicLoginBloc.dispose();
   // LoginBlocs().googleLoginBloc.dispose();
  }

  TextFormBloc usernameBloc = new TextFormBloc(
    validate: (String text){
      if(text.length <= 2){
        HazizzLogger.printLog("TextFormErrorTooShort");
        return TextFormErrorTooShort();
      }if(text.length >= 20){
        return TextFormErrorTooLong();
      }
      return TextFormFine();

    },
    handleErrorEvents: (HFormEvent event){
        if(event is UserNotFoundEvent){
          HazizzLogger.printLog("piritos444");
          return UserNotFoundState();
        }
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
        if(event is PasswordIncorrectEvent){
          return PasswordIncorrectState();
        }
      }
  );
  BasicLoginBloc basicLoginBloc;
 // LoginBlocs().googleLoginBloc googleLoginBloc;

  LoginWidgetBlocs(){
    basicLoginBloc = new BasicLoginBloc(usernameBloc, passwordBloc);
  //  googleLoginBloc = new LoginBlocs().googleLoginBloc();


    basicLoginBloc.state.listen((LoginState state){
      if(state is LoginSuccessState){

      }
    });

  }
}


