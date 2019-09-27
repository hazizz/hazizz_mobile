
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/auth/google_login_bloc.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

class GoogleSignInButtonWidget extends StatefulWidget {

  static const String link_privacy = "https://hazizz.github.io/privacy-en.txt";

  static const String link_terms_of_service = "https://hazizz.github.io/tos-en.txt";



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
    HazizzLogger.printLog("google bloc disposed");
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
        if(state is GoogleLoginWaitingState) {

        }else{


          if(state is GoogleLoginFailedState){

            errorText = locText(context, key: "error_signing_in_with_google");

          }
          else if(state is GoogleLoginHaveToAcceptConditionsState){
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                showRegistrationDialog(context).then((accepted){
                  HazizzLogger.printLog("showRegistrationDialog has accepted: $accepted");
                  if(accepted != null && accepted){
                    LoginBlocs().googleLoginBloc.dispatch(GoogleLoginAcceptedConditionsEvent());
                  }else{
                    LoginBlocs().googleLoginBloc.dispatch(GoogleLoginRejectConditionsEvent());
                  }
                })
            );


          }else if(state is GoogleLoginRejectedConditionsState){
            HazizzLogger.printLog("google signin: rejected and signing out");

            errorText = locText(context, key: "error_conditionsNotAccepted");
          }

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
            Container(width: MediaQuery.of(context).size.width, child: Text(errorText, style: TextStyle(), textAlign: TextAlign.center,))
          ],
        );
      },
    );
  }

  

}
