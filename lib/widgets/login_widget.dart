import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/blocs/google_login_bloc.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/controller/hashed_text_controller.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/widgets/google_sign_in_widget.dart';

import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';
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

  void proceedToApp(BuildContext context){
   // MainTabBlocs().initialize();
    AppState.mainAppPartStartProcedure();
    Navigator.popAndPushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {

    GoogleSignInButtonWidget googleSignInButtonWidget = GoogleSignInButtonWidget();

    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: LoginBlocs().googleLoginBloc,//loginWidgetBlocs.googleLoginBloc,
          listener: (context, state) {
            if(state is GoogleLoginSuccessfulState){
              proceedToApp(context);
            }
          },
        ),
        BlocListener(
          bloc: loginWidgetBlocs.basicLoginBloc,
          listener: (context, state) {
            if (state is LoginSuccessState) {
              proceedToApp(context);
            }
          },
        )
      ],

        /*
        final String assetName = 'assets/image.svg';
    final Widget svg = new SvgPicture.asset(
    assetName,
    semanticsLabel: 'Acme Logo'
    );
    */

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

                    /*
                    BlocBuilder(
                        bloc: loginWidgetBlocs.usernameBloc,
                        builder: (BuildContext context, HFormState state) {
                          String errorText = null;
                          if (state is UserNotFoundState) {
                            errorText = "No such user";
                          } else if (state is TextFormErrorTooShort) {
                            errorText = "too short mann...";
                          }
                          return TextField(
                            onChanged: (dynamic text) {
                              HazizzLogger.printLog("change: $text");
                              loginWidgetBlocs.usernameBloc.dispatch(TextFormValidate(text: text));
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
                    RaisedButton(
                        child: Text("Küldés"),
                        onPressed: () async {
                          HazizzLogger.printLog("log: pressed login button");
                          loginWidgetBlocs.basicLoginBloc.dispatch(
                              LoginButtonPressedTEST(
                                  password: _passwordTextEditingController.text,
                                  username: _usernameTextEditingController.text
                              )
                          );
                        }
                    ),
                    */



                    /*
                    RaisedButton(
                        child: Text("Registration"),
                        onPressed: () async {
                          Navigator.pushReplacementNamed(context, "registration");

                        }
                    ),
                    */
                  ],
                ),



              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        googleSignInButtonWidget
                      ],
                    ),
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
