
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../hazizz_localizations.dart';

class GoogleSignInButtonWidget extends StatefulWidget {

  Function onSuccess;

  GoogleSignInButtonWidget({Key key, this.onSuccess}) : super(key: key);

  @override
  _GoogleSignInButtonWidget createState() => _GoogleSignInButtonWidget();
}

class _GoogleSignInButtonWidget extends State<GoogleSignInButtonWidget> {
  
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential));
    print("signed in " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(
      text: locText(context, key: "sign_in_google"),
      onPressed: () async {

        FirebaseUser user = await _handleSignIn();
        print("log: user email: ${user.email}");
        print("log: user phone: ${await user.phoneNumber}");
        print("log: user photoUrl: ${await user.photoUrl}");
        print("log: user getIdToken: ${await user.getIdToken()}");

        print("log: pressed google button:");

        widget.onSuccess();



      },
      darkMode: true,
    );
  }

}
