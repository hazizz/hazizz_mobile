import 'package:flutter/material.dart';
import 'package:mobile/blocs/google_login_bloc.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/controller/hashed_text_controller.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/widgets/google_sign_in_widget.dart';



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
      child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/Logo.png',
              ),
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
                        print("change: $text");
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
                    print("log: pressed login button");
                    loginWidgetBlocs.basicLoginBloc.dispatch(
                        LoginButtonPressedTEST(
                            password: _passwordTextEditingController.text,
                            username: _usernameTextEditingController.text
                        )
                    );
                  }
              ),

              googleSignInButtonWidget,

              RaisedButton(
                  child: Text("Registration"),
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, "registration");

                  }
              ),
            ],
          ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
