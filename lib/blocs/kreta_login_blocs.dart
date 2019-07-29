import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import '../request_sender.dart';
import '../hazizz_response.dart';
import 'TextFormBloc.dart';

import 'package:mobile/exceptions/exceptions.dart';

//region KretaLoginEvents
abstract class KretaLoginEvent extends HEvent {
  KretaLoginEvent([List props = const []]) : super(props);
}

class KretaLoginButtonPressed extends KretaLoginEvent {
  final String username;
  final String password;
  final String schoolUrl;

  KretaLoginButtonPressed({
    @required this.username,
    @required this.password,
    @required this.schoolUrl
  }) : super([username, password, schoolUrl]);

  @override
  String toString() =>
      'KretaLoginButtonPressed { username: $username, password: $password }';
}

//endregion

//region KretaLoginStates
abstract class KretaLoginState extends HState {
  KretaLoginState([List props = const []]) : super(props);
}

class KretaLoginInitial extends KretaLoginState {
  @override
  String toString() => 'KretaLoginInitial';
}

class KretaLoginWaiting extends KretaLoginState {
  @override
  String toString() => 'KretaLoginWaiting';
}

class KretaLoginFailure extends KretaLoginState {
  final String error;

  KretaLoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'KretaLoginFailure { error: $error }';
}

class KretaLoginFailPasswordWrong extends KretaLoginState {

  KretaLoginFailPasswordWrong();

  @override
  String toString() => 'KretaLoginFailPasswordTooShort';
}
class KretaLoginFailUsernameWrong extends KretaLoginState {

  KretaLoginFailUsernameWrong();

  @override
  String toString() => 'KretaLoginFailUsernameWrong';
}

class KretaLoginSuccessState extends KretaLoginState {

  KretaLoginSuccessState();

  @override
  String toString() => 'KretaLoginSuccess';
}


//endregion

class SchoolItem{
  final String name, url;

  SchoolItem(this.name, this.url);
}


class SchoolItemState extends ItemListState{
  SchoolItemState([List props = const []]) : super(props);
}

class SchoolItemPickedState extends SchoolItemState{


  SchoolItemPickedState([List props = const []]) : super(props);

}


class SchoolItemPickerBloc extends ItemListPickerBloc {
  Map data;

  SchoolItemPickerBloc() {}

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {
    if (event is PickedEvent) {
      yield ItemListPickedState(item: event.item);
    }
    else if (event is ItemListLoadData) {
        yield Waiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(
            new KretaGetSchools()
            );

        if (hazizzResponse.isSuccessful) {
          data = hazizzResponse.convertedData;
         // listItemData = responseData;
            yield ItemListLoaded(data: data);
          
        }
      
    }
    super.mapEventToState(event);
  }
}




class KretaLoginBloc extends Bloc<KretaLoginEvent, KretaLoginState> {
  final TextFormBloc usernameBloc;
  final TextFormBloc passwordBloc;
  final SchoolItemPickerBloc schoolBloc;

  KretaLoginBloc(this.usernameBloc, this.passwordBloc, this.schoolBloc);

  KretaLoginState get initialState => KretaLoginInitial();


  @override
  Stream<KretaLoginState> mapEventToState(KretaLoginEvent event) async* {
    print("sentaa state asd");

    if (event is KretaLoginButtonPressed) {
      print("sentaa1");

      usernameBloc.dispatch(TextFormValidate(text: event.username));
      passwordBloc.dispatch(TextFormValidate(text: event.password));
      schoolBloc.dispatch(ItemListCheckPickedEvent());

      HFormState usernameState = usernameBloc.currentState;
      HFormState passwordState = passwordBloc.currentState;
      ItemListState schoolState = schoolBloc.currentState;
      print("log: usernameState: ${usernameState.toString()}");
      print("log: usernameState: ${usernameState.toString()}");


      if(usernameState is TextFormFine || usernameState is KretaUserNotFoundState) {
        if(passwordState is TextFormFine && schoolState is ItemListPickedState) { //usernameState is TextFormFine && passwordState is TextFormFine) {
          try {
            print("sentaa22");
            yield KretaLoginWaiting();
            HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaCreateSession(
              b_username: usernameBloc.lastText, b_password: passwordBloc.lastText,
              b_url: schoolBloc.pickedItem.url
              )
            );
            if(hazizzResponse.isSuccessful){
              yield KretaLoginSuccessState();
            }else if(hazizzResponse.hasPojoError){
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
class KretaUserNotFoundState extends HFormState {
  @override
  String toString() => 'KretaUserNotFoundState';
}


class PasswordIncorrectEvent extends HFormEvent {
  @override
  String toString() => 'PasswordIncorrectEvent';
}
class PasswordIncorrectState extends HFormState {
  @override
  String toString() => 'PasswordIncorrectState';
}


class KretaLoginPageBlocs{
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
          return KretaUserNotFoundState();
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

  SchoolItemPickerBloc schoolBloc = SchoolItemPickerBloc();

  KretaLoginBloc kretaLoginBloc;

  KretaLoginPageBlocs(){
    schoolBloc.dispatch(ItemListLoadData());
    kretaLoginBloc = new KretaLoginBloc(usernameBloc, passwordBloc, schoolBloc);
  }

  void dispose(){
    kretaLoginBloc.dispose();
    usernameBloc.dispose();
    passwordBloc.dispose();
    schoolBloc.dispose();
  }
}


