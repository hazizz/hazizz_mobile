import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/token_manager.dart';

class FacebookLoginBloc extends SocialLoginBloc{

  FacebookLogin facebookLogin = FacebookLogin();

  @override
  void initialize() {}

  @override
  Future<String> getSocialToken() async {
    await facebookLogin.logOut();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
    FacebookLoginResult result = await facebookLogin.logIn(["email", 'public_profile']);

    switch(result.status){
      case FacebookLoginStatus.loggedIn:
        print("facebook token: ${result.accessToken.token}");

        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        return result.accessToken.token;
      case FacebookLoginStatus.cancelledByUser:
        print("facebook token: ${result}, FacebookLoginStatus.cancelledByUser");
        return "canceled";
      case FacebookLoginStatus.error:
        print("facebook token: ${result.errorMessage}, FacebookLoginStatus.error, ${result.status.toString()}");
        return null;
    }
    print("facebook token: null, none");

    return null;
  }

  @override
  Future<HazizzResponse> loginRequest(String socialToken) async {
    return await TokenManager.createTokenWithFacebookAccount(socialToken);
  }

  @override
  Future<HazizzResponse> registerRequest(String socialToken) async {
    print("registerRequest: ${socialToken}");
    return await RequestSender().getAuthResponse(RegisterWithFacebookAccount(b_facebookToken: socialToken));
  }

  void reset(){
    this.dispatch(SocialLoginResetEvent());
  }

  @override
  Future<void> logout() async {
    await facebookLogin.logOut();
  }
}