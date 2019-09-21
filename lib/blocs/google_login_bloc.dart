import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:mobile/managers/token_manager.dart';

import '../hazizz_response.dart';
import '../logger.dart';
import '../request_sender.dart';
import 'auth_bloc.dart';
import 'login_bloc.dart';

abstract class GoogleLoginEvent extends HEvent {
  GoogleLoginEvent([List props = const []]) : super(props);
}

abstract class GoogleLoginState extends HState {
  GoogleLoginState([List props = const []]) : super(props);
}

class GoogleLoginButtonPressedEvent extends GoogleLoginEvent {
  @override String toString() => 'GoogleLoginButtonPressed';
}

class GoogleLoginResetEvent extends GoogleLoginEvent {
  @override String toString() => 'GoogleLoginResetEvent';
}

class GoogleLoginHaveToAcceptConditionsEvent extends GoogleLoginEvent {
  @override String toString() => 'GoogleLoginHaveToAcceptConditionsEvent';
}

class GoogleLoginAcceptedConditionsEvent extends GoogleLoginEvent {
  @override String toString() => 'GoogleLoginAcceptedConditionsEvent';
}

class GoogleLoginRejectConditionsEvent extends GoogleLoginEvent {
  @override String toString() => 'GoogleLoginRejectedConditionsState';
}



class GoogleLoginFineState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginFineState';
}

class GoogleLoginPressedButtonState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginFineState';
}
class GoogleLoginSuccessfulState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginSuccessfulState';
}

class GoogleLoginWaitingState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginWaitingState';
}

class GoogleLoginFailedState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginFailedState';
}

class GoogleLoginAcceptedConditionsState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginAcceptedConditionsState';
}

class GoogleLoginRejectedConditionsState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginRejectedConditionsState';
}

class GoogleLoginHaveToAcceptConditionsState extends GoogleLoginState {
  @override String toString() => 'GoogleLoginHaveToAcceptConditionsState';
}


class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {

  /*
  static final LoginBlocs().googleLoginBloc _singleton = new LoginBlocs().googleLoginBloc._internal();
  factory LoginBlocs().googleLoginBloc() {
    return _singleton;
  }
  LoginBlocs().googleLoginBloc._internal();
  */
  GoogleSignIn _googleSignIn;
  FirebaseAuth _auth;

  String _openIdToken;


  GoogleLoginBloc(){
    _googleSignIn = GoogleSignIn(scopes: [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/userinfo.profile",
      "openid"
    ]);
    _auth = FirebaseAuth.instance;
  }


  final AuthBloc authenticationBloc = AuthBloc();

  GoogleLoginState get initialState => GoogleLoginFineState();

  @override
  void dispose() {
    // TODO: implement dispose

    HazizzLogger.printLog("HazizzLog: google login bloc DISPOSED");
    authenticationBloc.dispose();
    super.dispose();
  }

  void reset(){
    this.dispatch(GoogleLoginResetEvent());
  }

  Future<void> logout() async{
    await _auth.signOut();
    await _googleSignIn.signOut();
  }


  @override
  Stream<GoogleLoginState> mapEventToState(GoogleLoginEvent event) async* {
    HazizzLogger.printLog("sentaa state asd");

    if (event is GoogleLoginButtonPressedEvent) {
      yield GoogleLoginWaitingState();
      


      HazizzLogger.printLog("HazizzLog: google login: 1");
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      HazizzLogger.printLog("HazizzLog: google login: 2");
      if(googleUser == null){
        yield GoogleLoginFineState();
      }
      HazizzLogger.printLog("HazizzLog: google login: 3");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      HazizzLogger.printLog("HazizzLog: google login: 4");

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      HazizzLogger.printLog("HazizzLog: google login: 5");


     // final AuthResult authResult = (await _auth.signInWithCredential(credential));
     // FirebaseUser user = authResult.user;
      final FirebaseUser user = (await _auth.signInWithCredential(credential));
      HazizzLogger.printLog("HazizzLog: signed in " + user.displayName);



      _openIdToken = googleAuth.idToken;

      logger.d("_openIdToken: ${_openIdToken}");
      HazizzLogger.printLog(_openIdToken);


      HazizzResponse hazizzResponseLogin = await TokenManager.createTokenWithGoolgeOpenId(_openIdToken);//RequestSender().getResponse(CreateToken.withGoogleAccount(q_openIdToken: _openIdToken));

      if(hazizzResponseLogin.isSuccessful) {
       // PojoTokens tokens = hazizzResponseLogin.convertedData;

       // await AppState.logInProcedure(tokens: tokens);

        yield GoogleLoginSuccessfulState();
        // proceed to the app

      }else if(hazizzResponseLogin.hasPojoError && hazizzResponseLogin.pojoError.errorCode == ErrorCodes.AUTH_TOKEN_INVALID.code){

        yield GoogleLoginHaveToAcceptConditionsState();
        
      }else{
        await logout();
        yield GoogleLoginFailedState();
      }

    }else if(event is GoogleLoginAcceptedConditionsEvent){
      yield GoogleLoginWaitingState();
      HazizzResponse hazizzResponseRegistration = await TokenManager.createTokenWithGoolgeOpenId(_openIdToken);
      if(hazizzResponseRegistration.isSuccessful){
        HazizzResponse hazizzResponseLogin2 = await TokenManager.createTokenWithGoolgeOpenId(_openIdToken);

        // proceed to the app

     //   await AppState.logInProcedure(tokens: hazizzResponseLogin2.convertedData);
        yield GoogleLoginSuccessfulState();

      }else{
        await logout();
        yield GoogleLoginFailedState();
      }
    }else if(event is GoogleLoginRejectConditionsEvent){
      await logout();
      yield GoogleLoginRejectedConditionsState();
    }
    
    
    else if(event is GoogleLoginResetEvent){
      HazizzLogger.printLog("");
      yield GoogleLoginFineState();
    }
  }
}


class LoginBlocs{
  final GoogleLoginBloc googleLoginBloc = GoogleLoginBloc();
 // final BasicLoginBloc basicLoginBloc = BasicLoginBloc();

  static final LoginBlocs _singleton = new LoginBlocs._internal();
  factory LoginBlocs() {
    return _singleton;
  }
  LoginBlocs._internal();
}