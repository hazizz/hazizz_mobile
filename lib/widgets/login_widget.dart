
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/controller/hashed_text_controller.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../hazizz_localizations.dart';

class LoginWidget extends StatefulWidget {

  LoginWidget({Key key}) : super(key: key);

  @override
  _LoginWidget createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginWidget> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  final LoginPageBlocs LoginWidgetBlocs = new LoginPageBlocs();

  final TextEditingController _usernameTextEditingController =
  TextEditingController();
  final HashedTextEditingController _passwordTextEditingController =
  HashedTextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    LoginWidgetBlocs.loginBloc.dispose();
    LoginWidgetBlocs.usernameBloc.dispose();
    LoginWidgetBlocs.passwordBloc.dispose();
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
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
    return Column(
          children: <Widget>[
            Image.asset(
              'assets/images/Logo.png',
            ),
            BlocBuilder(
                bloc: LoginWidgetBlocs.usernameBloc,
                builder: (BuildContext context, HFormState state) {
                  String errorText = null;
                  if (state is UserNotFoundState) {
                    errorText = "No such user";
                  } else if (state is TextFormErrorTooShort) {
                    errorText = "too short mann...";
                  }
                  return TextField(
                    onChanged: (dynamic text) {
                      print("change: $text");
                      LoginWidgetBlocs.usernameBloc.dispatch(TextFormValidate(text: text));
                    },
                    controller: _usernameTextEditingController,
                    textInputAction: TextInputAction.next,
                    decoration:
                    InputDecoration(labelText: "Age", errorText: errorText),
                  );
                }),
            TextFormField(
              obscureText: true,
              maxLines: 1,
              autofocus: false,
              controller: _passwordTextEditingController,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            BlocListener(
              bloc: LoginWidgetBlocs.loginBloc,
              listener: (context, state) {
                if (state is LoginSuccessState) {
                  //  Navigator.of(context).pushNamed('/details');
                  Navigator.popAndPushNamed(context, "/");
                }
              },
              child: RaisedButton(
                  child: Text("Küldés"),
                  onPressed: () async {
                    print("log: pressed login button");
                    LoginWidgetBlocs.loginBloc.dispatch(
                        LoginButtonPressedTEST(
                            password: _passwordTextEditingController.text,
                            username: _usernameTextEditingController.text
                        )
                    );
                  }
              ),
            ),



            GoogleSignInButton(
              text: locText(context, key: "sign_in_google"),
              onPressed: () async {

                FirebaseUser user = await _handleSignIn();
                print("log: user email: ${user.email}");
                print("log: user phone: ${await user.phoneNumber}");
                print("log: user photoUrl: ${await user.photoUrl}");
                print("log: user getIdToken: ${await user.getIdToken()}");

                print("log: pressed google button:");
              },
              darkMode: true,
            ),


            RaisedButton(
                child: Text("Registration"),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, "registration");

                }
            ),
          ],
        );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
