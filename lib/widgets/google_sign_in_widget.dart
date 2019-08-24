
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/google_login_bloc.dart';

import '../hazizz_localizations.dart';

class GoogleSignInButtonWidget extends StatefulWidget {


  GoogleSignInButtonWidget({Key key, }) : super(key: key){
  }

  @override
  _GoogleSignInButtonWidget createState() => _GoogleSignInButtonWidget();
}

class _GoogleSignInButtonWidget extends State<GoogleSignInButtonWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    LoginBlocs().googleLoginBloc.reset();
   // LoginBlocs().googleLoginBloc().dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: LoginBlocs().googleLoginBloc,
      builder: (context, state){
        String errorText = "";
        if(state is GoogleLoginFailedState){

          errorText = locText(context, key: "error_signing_in_with_google");
        }

         return Column(
          children: <Widget>[
            GoogleSignInButton(
              text: locText(context, key: "sign_in_google"),
              onPressed: () {
                LoginBlocs().googleLoginBloc.dispatch(GoogleLoginButtonPressedEvent());
              },
              darkMode: true,
            ),
            Text(errorText, style: TextStyle(color: Theme.of(context).accentColor),)
          ],
        );
      },
    );
  }

  

}
