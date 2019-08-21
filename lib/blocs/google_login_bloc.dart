import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:bloc/bloc.dart';

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


class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {

  /*
  static final LoginBlocs().googleLoginBloc _singleton = new LoginBlocs().googleLoginBloc._internal();
  factory LoginBlocs().googleLoginBloc() {
    return _singleton;
  }
  LoginBlocs().googleLoginBloc._internal();
  */


  final AuthBloc authenticationBloc = AuthBloc();

  GoogleLoginState get initialState => GoogleLoginFineState();

  @override
  void dispose() {
    // TODO: implement dispose

    print("log: google login bloc DISPOSED");
    authenticationBloc.dispose();
    super.dispose();
  }

  void reset(){
    this.dispatch(GoogleLoginResetEvent());
  }


  @override
  Stream<GoogleLoginState> mapEventToState(GoogleLoginEvent event) async* {
    print("sentaa state asd");

    if (event is GoogleLoginButtonPressedEvent) {
      yield GoogleLoginWaitingState();
      final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/userinfo.profile",
        "openid"
      ]);
      final FirebaseAuth _auth = FirebaseAuth.instance;


      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;


      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential));
      print("signed in " + user.displayName);


      final String openIdToken = googleAuth.idToken;

      logger.d("openIdToken: ${openIdToken}");
      print(openIdToken);


      HazizzResponse hazizzResponseLogin = await RequestSender().getResponse(CreateTokenWithGoogleAccount(b_openIdToken: openIdToken));

      if(hazizzResponseLogin.isSuccessful) {
        PojoTokens tokens = hazizzResponseLogin.convertedData;

        await AppState.logInProcedure(tokens: tokens);

        yield GoogleLoginSuccessfulState();
        // proceed to the app



      }else{
        HazizzResponse hazizzResponseRegistration = await RequestSender().getResponse(RegisterWithGoogleAccount(b_openIdToken: openIdToken));
        if(hazizzResponseRegistration.isSuccessful){
          HazizzResponse hazizzResponseLogin2 = await RequestSender().getResponse(CreateTokenWithGoogleAccount(b_openIdToken: openIdToken));

          // proceed to the app

          await AppState.logInProcedure(tokens: hazizzResponseLogin2.convertedData);
          yield GoogleLoginSuccessfulState();

        }else{
          //registration with googleopenid failed
          yield GoogleLoginFailedState();
        }
      }

    }else if(event is GoogleLoginResetEvent){
      print("");
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