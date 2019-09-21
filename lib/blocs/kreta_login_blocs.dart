import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/blocs/selected_session_bloc.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/managers/token_manager.dart';
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

class KretaLoginDataChanged extends KretaLoginEvent {
  @override
  String toString() =>
      'KretaLoginDataChanged';
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
  final PojoError error;

  KretaLoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'KretaLoginFailure { error: $error }';
}

class KretaLoginSomethingWentWrong extends KretaLoginState {

  @override
  String toString() => 'KretaLoginSomethingWentWrong';
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
      pickedItem = event.item;
      yield ItemListPickedState(item: event.item);
    }
    else if (event is ItemListLoadData) {
        yield Waiting();
        HazizzResponse hazizzResponse = await RequestSender().getResponse(KretaGetSchools());

        if (hazizzResponse.isSuccessful) {
          data = hazizzResponse.convertedData;
          HazizzLogger.printLog("kréta schools: ${data.length}");
         // listItemData = responseData;
            yield ItemListLoaded(data: data);
          
        }else{
          HazizzResponse hazizzResponse = await RequestSender().getResponse(KretaGetSchools());

          if (hazizzResponse.isSuccessful) {
            data = hazizzResponse.convertedData;
            // listItemData = responseData;
            yield ItemListLoaded(data: data);

          }
        }
      
    }
    super.mapEventToState(event);
  }
}



Future setSession(PojoSession newSession, {String password}) async {
  if(await KretaSessionManager.isRememberPassword()){
    newSession.password = password;
  }
  SelectedSessionBloc().dispatch(SelectedSessionSetEvent(newSession));

}


class KretaLoginBloc extends Bloc<KretaLoginEvent, KretaLoginState> {
  TextEditingController usernameController;
  TextEditingController passwordController;
 // final TextFormBloc usernameBloc;
 // final TextFormBloc passwordBloc;
  final SchoolItemPickerBloc schoolBloc;

  PojoSession session;

  bool isAuth = false;

  KretaLoginBloc(this.schoolBloc){
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameController.addListener((){
      HazizzLogger.printLog("change");
      dispatch(KretaLoginDataChanged());
    });
    passwordController.addListener((){
      HazizzLogger.printLog("change");
      dispatch(KretaLoginDataChanged());
    });
  }

  KretaLoginBloc.auth(this.usernameController, this.passwordController, this.schoolBloc, this.session){
    usernameController.addListener((){
      HazizzLogger.printLog("change");
      dispatch(KretaLoginDataChanged());
    });
    passwordController.addListener((){
      HazizzLogger.printLog("change");
      dispatch(KretaLoginDataChanged());
    });
    isAuth = true;

  }


  KretaLoginState get initialState => KretaLoginInitial();


  @override
  void dispose() {
    usernameController?.dispose();
    passwordController?.dispose();
    schoolBloc?.dispose();
    super.dispose();
  }

  @override
  Stream<KretaLoginState> mapEventToState(KretaLoginEvent event) async* {
    if(state is KretaLoginDataChanged){
      if(currentState is KretaLoginFailure){
        yield KretaLoginInitial();
      }
    }

    if (event is KretaLoginButtonPressed) {
      HazizzLogger.printLog("sentaa1: $isAuth");
      if(isAuth){
       // passwordBloc.dispatch(TextFormValidate(text: event.password));
        if(true){
          yield KretaLoginWaiting();
          HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaAuthenticateSession(
              p_session: session.id.toString(), b_password: passwordController.text)
          );
          if(hazizzResponse.isSuccessful){
            HazizzLogger.printLog("debuglol111");

            PojoSession newSession = hazizzResponse.convertedData;
            HazizzLogger.printLog("debuglol222");

            setSession(newSession, password: passwordController.text);
            HazizzLogger.printLog("debuglol1");
            yield KretaLoginSuccessState();
          }else if(hazizzResponse.pojoError != null) {
            HazizzLogger.printLog("assdad: ${hazizzResponse.pojoError.errorCode}");
            if(hazizzResponse.pojoError.errorCode ==
                ErrorCodes.THERA_AUTHENTICATION_ERROR.code) {
              yield KretaLoginFailure(error: hazizzResponse.pojoError);
            } else if(hazizzResponse.pojoError.errorCode == ErrorCodes.GENERAL_THERA_ERROR.code) {
              yield KretaLoginFailure(error: hazizzResponse.pojoError);
            }
            else {
              yield KretaLoginSomethingWentWrong();
            }
          }else {
            yield KretaLoginSomethingWentWrong();
          }
        }
      }


      //usernameBloc.dispatch(TextFormValidate(text: event.username));
     // passwordBloc.lastText = "---";

    //  passwordBloc.dispatch(TextFormValidate(text: event.password));
      schoolBloc.dispatch(ItemListCheckPickedEvent());

   //   HFormState usernameState = usernameBloc.currentState;
   //   HFormState passwordState = passwordBloc.currentState;
      ItemListState schoolState = schoolBloc.currentState;
     // passwordBloc.dispatch(TextFormValidate(text: e))
      /*
      HazizzLogger.printLog("log: usernameState: ${usernameState.toString()}");
      HazizzLogger.printLog("log: passwordState: ${passwordState.toString()}");
      HazizzLogger.printLog("log: schoolState: ${schoolState.toString()}");
      */


   //   passwordBloc.validate

   //   HazizzLogger.printLog("boi: ${usernameState}, ${passwordState}, ${schoolState}");
      HazizzLogger.printLog("sentaa22");
      yield KretaLoginWaiting();
      HazizzResponse hazizzResponse = await RequestSender().getResponse(new KretaCreateSession(
          b_username: usernameController.text, b_password: passwordController.text,
          b_url: schoolBloc.pickedItem.url)
      );
      if(hazizzResponse.isSuccessful){
        PojoSession newSession = hazizzResponse.convertedData;
        setSession(newSession, password: passwordController.text);
        yield KretaLoginSuccessState();
      }else if(hazizzResponse.pojoError != null){
        HazizzLogger.printLog("assdad: ${hazizzResponse.pojoError.errorCode}");
        if(hazizzResponse.pojoError.errorCode ==
            ErrorCodes.THERA_AUTHENTICATION_ERROR.code) {
          yield KretaLoginFailure(error: hazizzResponse.pojoError);
        } else if(hazizzResponse.pojoError.errorCode == ErrorCodes.GENERAL_THERA_ERROR.code) {
          yield KretaLoginFailure(error: hazizzResponse.pojoError);
        }
      }else{
        yield KretaLoginSomethingWentWrong();

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
  /*
  TextFormBloc usernameBloc = new TextFormBloc(
    validate: (String text){
      /*
      if(text.length <= 2){
        HazizzLogger.printLog("TextFormErrorTooShort");
        return TextFormErrorTooShort();
      }if(text.length >= 20){
        return TextFormErrorTooLong();
      }
      */
      return TextFormFine();

    },
      /*
    handleErrorEvents: (HFormEvent event){
        if(event is UserNotFoundEvent){
          HazizzLogger.printLog("piritos444");
          return KretaUserNotFoundState();
        }
    }
    */
  );
  TextFormBloc passwordBloc = new TextFormBloc(
      validate: (String text){
       // HazizzLogger.printLog("length: ${text.length}");
      /*  if(text.length < 4) {
      //    HazizzLogger.printLog("returnss::::");
          return TextFormErrorTooShort();
        }
        */
        return TextFormFine();
      },
      /*
      handleErrorEvents: (HFormEvent event){
       /* if(event is PasswordIncorrectEvent){
          return PasswordIncorrectState();
        }
        */
      }
      */
  );
  */

  SchoolItemPickerBloc schoolBloc = SchoolItemPickerBloc();

  TextEditingController usernameController = TextEditingController();

  KretaLoginBloc kretaLoginBloc;

  KretaLoginPageBlocs(){
    schoolBloc.dispatch(ItemListLoadData());
    kretaLoginBloc = new KretaLoginBloc(schoolBloc);
  }

  KretaLoginPageBlocs.auth({@required PojoSession session}){
    schoolBloc.dispatch(PickedEvent(item: SchoolItem(session.url, session.url) ));
    usernameController.text = session.username;

    kretaLoginBloc = new KretaLoginBloc.auth(usernameController, TextEditingController(), schoolBloc, session);
  }

  void dispose(){
    kretaLoginBloc?.dispose();
    usernameController?.dispose();
  //  usernameBloc.dispose();
 //   passwordBloc.dispose();
    schoolBloc?.dispose();
  }
}


