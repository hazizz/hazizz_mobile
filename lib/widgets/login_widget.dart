import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/blocs/auth/google_login_bloc.dart';
import 'package:mobile/blocs/auth/login_bloc.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/controller/hashed_text_controller.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/widgets/google_sign_in_widget.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'notebook_background_widget.dart';



class LoginWidget extends StatefulWidget {

  LoginWidget({Key key}) : super(key: key);

  @override
  _LoginWidget createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginWidget> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  final LoginWidgetBlocs loginWidgetBlocs = new LoginWidgetBlocs();

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
    loginWidgetBlocs.dispose();
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  Future proceedToApp(BuildContext context) async {
   // MainTabBlocs().initialize();
    await AppState.mainAppPartStartProcedure();
    Navigator.popAndPushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {

    SocialSignInButtonWidget googleSignInButtonWidget = SocialSignInButtonWidget.google();
    SocialSignInButtonWidget facebookSignInButtonWidget = SocialSignInButtonWidget.facebook();

    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: LoginBlocs().googleLoginBloc,//loginWidgetBlocs.googleLoginBloc,
          listener: (context, state) async {
            if(state is SocialLoginSuccessfulState){
              print("proceedToApp");
              await proceedToApp(context);
            }
          },
        ),
        BlocListener(
          bloc: LoginBlocs().facebookLoginBloc,
          listener: (context, state) async {
            if (state is SocialLoginSuccessfulState) {
              print("proceedToApp");

              await proceedToApp(context);
            }
          },
        )
      ],

      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
            children: <Widget>[


              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                  "assets/images/hatter-1.svg",
                  // semanticsLabel: 'Acme Logo'
                  fit: BoxFit.fitHeight,

                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),

              Container(width: MediaQuery.of(context).size.width, height: 60, color: Colors.white,),



              Column(
                  children: <Widget>[

                    Stack(
                      children: <Widget>[
                        SafeArea(
                          child: NotebookBackgroundWidget(),
                        ),
                        Image.asset(
                          'assets/images/Logo.png',
                        ),
                      ],
                    ),

                    Expanded(child: AutoSizeText(locText(context, key: "login"), style: TextStyle(/*fontSize: 60,*/ fontWeight: FontWeight.w800, color: HazizzTheme.blue, ), maxLines: 1, minFontSize: 44,)),

                  ],
                ),



              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            googleSignInButtonWidget
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            facebookSignInButtonWidget
                          ],
                        ),
                      ],
                    )
                  ),
                )
              )
            ],
          ),
      ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
