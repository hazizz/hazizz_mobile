
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/auth/google_login_bloc.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:mobile/custom/hazizz_localizations.dart';

enum SocialSignInMode{ google, facebook }

class SocialSignInButtonWidget extends StatefulWidget {

  static const String link_privacy = "https://hazizz.github.io/privacy-en.txt";

  static const String link_terms_of_service = "https://hazizz.github.io/tos-en.txt";

  SocialSignInMode socialSignInMode;



  SocialSignInButtonWidget.google({Key key, }) : super(key: key){
    socialSignInMode = SocialSignInMode.google;
  }

  SocialSignInButtonWidget.facebook({Key key, }) : super(key: key){
    socialSignInMode = SocialSignInMode.facebook;
  }

  @override
  _SocialSignInButtonWidget createState() => _SocialSignInButtonWidget();
}

class _SocialSignInButtonWidget extends State<SocialSignInButtonWidget> {

  @override
  void initState() {
    super.initState();
  }

  String getTextOnSocialButton(){
    return widget.socialSignInMode == SocialSignInMode.google
        ? locText(context, key: "sign_in_google")
        : locText(context, key: "sign_in_facebook");
  }

  void onPressedSocialButton(){

    return widget.socialSignInMode == SocialSignInMode.google
        ? LoginBlocs().googleLoginBloc.dispatch(SocialLoginButtonPressedEvent())
        : LoginBlocs().facebookLoginBloc.dispatch(SocialLoginButtonPressedEvent());
  }

  Widget googleSignInButton(){
    return GoogleSignInButton(
      text: getTextOnSocialButton(),

      onPressed: (){onPressedSocialButton();},
      darkMode: true,
    );
  }

  Widget facebookSignInButton(){
    return FacebookSignInButton(
      text: getTextOnSocialButton(),

      onPressed: (){onPressedSocialButton();} ,
    );
  }


  @override
  void dispose() {
    HazizzLogger.printLog("google bloc disposed");
    LoginBlocs().reset();
   // LoginBlocs().SocialLoginBloc().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.socialSignInMode == SocialSignInMode.google ? LoginBlocs().googleLoginBloc :  LoginBlocs().facebookLoginBloc,
      builder: (context, state){
        String errorText = "";
        if(state is SocialLoginWaitingState) {

        }else{


          if(state is SocialLoginFailedState){

            if(state.error != null && state.error.errorCode == 26){
              errorText = locText(context, key: "error_signing_in_with_facebook_no_email");
            }else{
              errorText = widget.socialSignInMode == SocialSignInMode.google
                  ? locText(context, key: "error_signing_in_with_google")
                  : locText(context, key: "error_signing_in_with_facebook");
            }



          }
          else if(state is SocialLoginHaveToAcceptConditionsState){
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                showRegistrationDialog(context).then((accepted){
                  HazizzLogger.printLog("showRegistrationDialog has accepted: $accepted");
                  if(accepted != null && accepted){
                    widget.socialSignInMode == SocialSignInMode.google
                    ? LoginBlocs().googleLoginBloc.dispatch(SocialLoginAcceptedConditionsEvent())
                    : LoginBlocs().facebookLoginBloc.dispatch(SocialLoginAcceptedConditionsEvent());

                  }else{
                    widget.socialSignInMode == SocialSignInMode.google
                        ? LoginBlocs().googleLoginBloc.dispatch(SocialLoginRejectConditionsEvent())
                        : LoginBlocs().facebookLoginBloc.dispatch(SocialLoginRejectConditionsEvent());

                  }
                })
            );

          }else if(state is SocialLoginRejectedConditionsState){
            HazizzLogger.printLog("google signin: rejected and signing out");

            errorText = locText(context, key: "error_conditionsNotAccepted");
          }

        }

         return Column(
          children: <Widget>[
            widget.socialSignInMode == SocialSignInMode.google
            ? googleSignInButton()
            : facebookSignInButton(),
            Container(width: MediaQuery.of(context).size.width, child: Text(errorText, style: TextStyle(), textAlign: TextAlign.center,))
          ],
        );
      },
    );
  }

  

}
