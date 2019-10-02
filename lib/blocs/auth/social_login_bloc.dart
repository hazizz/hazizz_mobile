import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/auth/facebook_login_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/custom_exception.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/managers/token_manager.dart';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/custom/logger.dart';

import 'google_login_bloc.dart';

abstract class SocialLoginEvent extends HEvent {
  SocialLoginEvent([List props = const []]) : super(props);
}

abstract class SocialLoginState extends HState {
  SocialLoginState([List props = const []]) : super(props);
}

class SocialLoginButtonPressedEvent extends SocialLoginEvent {
  @override String toString() => 'SocialLoginButtonPressed';
}

class SocialLoginResetEvent extends SocialLoginEvent {
  @override String toString() => 'SocialLoginResetEvent';
}

class SocialLoginHaveToAcceptConditionsEvent extends SocialLoginEvent {
  @override String toString() => 'SocialLoginHaveToAcceptConditionsEvent';
}

class SocialLoginAcceptedConditionsEvent extends SocialLoginEvent {
  @override String toString() => 'SocialLoginAcceptedConditionsEvent';
}

class SocialLoginRejectConditionsEvent extends SocialLoginEvent {
  @override String toString() => 'SocialLoginRejectedConditionsState';
}



class SocialLoginFineState extends SocialLoginState {
  @override String toString() => 'SocialLoginFineState';
}

class SocialLoginPressedButtonState extends SocialLoginState {
  @override String toString() => 'SocialLoginFineState';
}
class SocialLoginSuccessfulState extends SocialLoginState {
  @override String toString() => 'SocialLoginSuccessfulState';
}

class SocialLoginWaitingState extends SocialLoginState {
  @override String toString() => 'SocialLoginWaitingState';
}

class SocialLoginFailedState extends SocialLoginState {
  PojoError error;
  SocialLoginFailedState({this.error}): super([error]);

  @override String toString() => 'SocialLoginFailedState';
}

class SocialLoginAcceptedConditionsState extends SocialLoginState {
  @override String toString() => 'SocialLoginAcceptedConditionsState';
}

class SocialLoginRejectedConditionsState extends SocialLoginState {
  @override String toString() => 'SocialLoginRejectedConditionsState';
}

class SocialLoginHaveToAcceptConditionsState extends SocialLoginState {
  @override String toString() => 'SocialLoginHaveToAcceptConditionsState';
}


class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {

  /*
  static final SocialLoginBloc _singleton = new SocialLoginBloc._internal();
  factory SocialLoginBloc() {
    return _singleton;
  }
  SocialLoginBloc._internal();
  */

  String _socialToken;

  void initialize(){}

  Future<String> getSocialToken(){}

  Future<HazizzResponse> loginRequest(String socialToken){}

  Future<HazizzResponse> registerRequest(String socialToken){}



  SocialLoginBloc(){
    initialize();
  }


  SocialLoginState get initialState => SocialLoginFineState();

  @override
  void dispose() {
    // TODO: implement dispose
    HazizzLogger.printLog("google login bloc DISPOSED");
    super.dispose();
  }

  void reset(){
    this.dispatch(SocialLoginResetEvent());
  }

  Future<void> logout() async{}


  @override
  Stream<SocialLoginState> mapEventToState(SocialLoginEvent event) async* {

    if (event is SocialLoginButtonPressedEvent) {
      yield SocialLoginWaitingState();

      _socialToken = null;

      try{
        _socialToken = await getSocialToken();
        if(_socialToken == null){
          Crashlytics().recordError(CustomException("Social Token is null"), StackTrace.current);
          yield SocialLoginFineState();
        }
      }catch(exception, stacktrace){
        Crashlytics().recordError(exception, stacktrace);
        yield SocialLoginFineState();
      }

      HazizzLogger.printLog("socialToken is not null: ${_socialToken != null}");

     // HazizzResponse hazizzResponseLogin = await TokenManager.createTokenWithGoolgeOpenId(_openIdToken);
      HazizzResponse hazizzResponseLogin = await loginRequest(_socialToken);
      if(hazizzResponseLogin.isSuccessful) {
        yield SocialLoginSuccessfulState();
        // proceed to the app

      }else if(hazizzResponseLogin.hasPojoError && hazizzResponseLogin.pojoError.errorCode == ErrorCodes.AUTH_TOKEN_INVALID.code){

        yield SocialLoginHaveToAcceptConditionsState();

      }else{

        await logout();
        yield SocialLoginFailedState(error: hazizzResponseLogin.pojoError);
      }
    }

    else if(event is SocialLoginAcceptedConditionsEvent){
      yield SocialLoginWaitingState();
      HazizzResponse hazizzResponseRegistration = await registerRequest(_socialToken);//await RequestSender().getResponse(RegisterWithGoogleAccount(b_openIdToken: _openIdToken));//await TokenManager.createTokenWithGoolgeOpenId(_openIdToken);
      if(hazizzResponseRegistration.isSuccessful){
        HazizzResponse hazizzResponseLogin2 = await loginRequest(_socialToken);// await TokenManager.createTokenWithGoolgeOpenId(_openIdToken);

        if(hazizzResponseLogin2.isSuccessful){
          yield SocialLoginSuccessfulState();
        }else{
          HazizzResponse hazizzResponseLogin3 = await loginRequest(_socialToken);//await TokenManager.createTokenWithGoolgeOpenId(_openIdToken);
          if(hazizzResponseLogin3.isSuccessful){
            yield SocialLoginSuccessfulState();
          }else{
            yield SocialLoginFailedState(error: hazizzResponseLogin3.pojoError);
          }
        }
        // proceed to the app

      }else{
        Crashlytics().recordError(CustomException("Social login failed second time"), StackTrace.current);
        await logout();
        yield SocialLoginFailedState(error: hazizzResponseRegistration.pojoError);
      }
    }

     if(event is SocialLoginRejectConditionsEvent){
      await logout();
      yield SocialLoginRejectedConditionsState();
    }


    else if(event is SocialLoginResetEvent){
      HazizzLogger.printLog("");
      yield SocialLoginFineState();
    }
  }
}


class LoginBlocs{
  final GoogleLoginBloc googleLoginBloc = GoogleLoginBloc();
  final FacebookLoginBloc facebookLoginBloc = FacebookLoginBloc();

  static final LoginBlocs _singleton = new LoginBlocs._internal();
  factory LoginBlocs() {
    return _singleton;
  }
  LoginBlocs._internal();

  void reset(){
    googleLoginBloc.reset();
    facebookLoginBloc.reset();
  }


}
