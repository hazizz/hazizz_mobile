import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/token_manager.dart';

class GoogleLoginBloc extends SocialLoginBloc{
  GoogleSignIn _googleSignIn;
  FirebaseAuth _auth;

  @override
  void initialize() {
    _googleSignIn = GoogleSignIn(scopes: [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/userinfo.profile",
      "openid",
    ]);
    _auth = FirebaseAuth.instance;
  }

  @override
  Future<String> getSocialToken() async {
    HazizzLogger.printLog("google login: 1");
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    HazizzLogger.printLog("google login: 2");

    HazizzLogger.printLog("google login: 3");

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    HazizzLogger.printLog("google login: 4");

    debugPrint("access Token 1: ${googleAuth.accessToken}");

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    HazizzLogger.printLog("google login: 5");

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    HazizzLogger.printLog("signed in " + user.displayName);

    String _openIdToken = googleAuth.idToken;

    HazizzLogger.printLog("google login: success: openIdToken is not null: ${_openIdToken != null}");

    return _openIdToken;
  }

  @override
  Future<HazizzResponse> loginRequest(String socialToken) async {
    return await TokenManager.createTokenWithGoolgeOpenId(socialToken);
  }

  @override
  Future<HazizzResponse> registerRequest(String socialToken) async {
    return await RequestSender().getAuthResponse(RegisterWithGoogleAccount(b_openIdToken: socialToken));
  }

  void reset(){
    this.dispatch(SocialLoginResetEvent());
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}