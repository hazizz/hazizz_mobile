import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPublic.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/notification/notification.dart';
import '../hazizz_response.dart';
import '../request_sender.dart';
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

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
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

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authenticationBloc = AuthBloc();
  final TextFormBloc usernameBloc;
  final TextFormBloc passwordBloc;

  LoginBloc(this.usernameBloc, this.passwordBloc);

  LoginState get initialState => LoginInitial();


  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    print("sentaa state asd");

    if (event is LoginButtonPressedTEST) {
      print("sentaa1");

      usernameBloc.dispatch(TextFormValidate(text: event.username));
      passwordBloc.dispatch(TextFormValidate(text: event.password));

      HFormState usernameState = usernameBloc.currentState;
      HFormState passwordState = passwordBloc.currentState;
      print("log: usernameState: ${usernameState.toString()}");
      print("log: usernameState: ${usernameState.toString()}");

      if(usernameState is TextFormFine || usernameState is UserNotFoundState) {
        if(passwordState is TextFormFine) { //usernameState is TextFormFine && passwordState is TextFormFine) {
          try {
            print("sentaa22");
            await TokenManager.fetchTokens(event.username, event.password);
            HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyInfoPublic());
            if(hazizzResponse.isSuccessful){
              print("log: info: 1");

              PojoMeInfoPublic meInfo = hazizzResponse.convertedData;
              print("log: info: 2");

              InfoCache.setMyId(meInfo.id);
              InfoCache.setMyUsername(meInfo.username);
              InfoCache.setMyDisplayName(meInfo.displayName);

              MainTabBlocs().initialize();
              authenticationBloc.dispatch(LoggedIn());
              yield LoginSuccessState();
            //  HazizzNotification.scheduleNotificationAlarmManager(await HazizzNotification.getNotificationTime());
            }

          }on HResponseError catch(e) {
            print("piritos111");
            int errorCode = e.error.errorCode;
            if(ErrorCodes.USER_NOT_FOUND.equals(errorCode)) {
              print("piritos222");
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


class LoginPageBlocs{
  TextFormBloc usernameBloc = new TextFormBloc(
    validate: (String text){
      if(text.length <= 2){
        print("TextFormErrorTooShort");
        return TextFormErrorTooShort();
      }if(text.length >= 20){
        return TextFormErrorTooLong();
      }
      return TextFormFine();

    },
    handleErrorEvents: (HFormEvent event){
        if(event is UserNotFoundEvent){
          print("piritos444");
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
  LoginBloc loginBloc;

  LoginPageBlocs(){
    loginBloc = new LoginBloc(usernameBloc, passwordBloc);
  }
}


