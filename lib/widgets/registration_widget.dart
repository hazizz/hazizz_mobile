

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobile/blocs/other/text_form_bloc.dart';
import 'package:mobile/blocs/auth/login_bloc.dart';
import 'package:mobile/blocs/auth/registration_bloc.dart';
import 'package:mobile/controller/hashed_text_controller.dart';

import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/src/button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';



class RegistrationWidget extends StatefulWidget {

  RegistrationWidget({Key key}) : super(key: key);

  @override
  _RegistrationWidget createState() => _RegistrationWidget();
}

class _RegistrationWidget extends State<RegistrationWidget> with SingleTickerProviderStateMixin {
  final RegistrationPageBlocs registrationBlocs = new RegistrationPageBlocs();

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final HashedTextEditingController _passwordTextEditingController = HashedTextEditingController();


  @override
  void initState() {
    _usernameTextEditingController.addListener(
        (){
          registrationBlocs.usernameBloc.dispatch(TextFormValidate(text: _usernameTextEditingController.text));
        }
    );
    _emailTextEditingController.addListener(
        (){
          registrationBlocs.emailBloc.dispatch(TextFormValidate(text: _emailTextEditingController.text));
        }
    );
    _passwordTextEditingController.addListener(
        (){
          // registrationBlocs.usernameBloc.dispatch(TextFormValidate(text: _usernameTextEditingController.text));
        }
    );
    super.initState();
  }

  @override
  void dispose() {
    registrationBlocs.registrationBloc.dispose();
    registrationBlocs.usernameBloc.dispose();
    registrationBlocs.passwordBloc.dispose();
    _usernameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child:
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/Logo.png',
                  ),
                  BlocBuilder(
                      bloc: registrationBlocs.usernameBloc,
                      builder: (BuildContext context, HFormState state) {
                        String errorText = null;
                        if (state is TextFormUsernameTakenState) {
                          errorText = "This username is already taken";
                        } else if (state is TextFormErrorTooShort) {
                          errorText = "too short mann...";
                        }
                        return TextField(
                          controller: _usernameTextEditingController,
                          textInputAction: TextInputAction.next,
                          decoration:
                          InputDecoration(labelText: "Username", errorText: errorText),
                        );
                      }
                  ),
                  BlocBuilder(
                      bloc: registrationBlocs.emailBloc,
                      builder: (BuildContext context, HFormState state) {
                        String errorText = null;
                        if (state is TextFormEmailInvalidState) {
                          errorText = "Invalid email";
                        }
                        return TextField(

                          controller: _emailTextEditingController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(labelText: "Email", errorText: errorText),
                        );
                      }
                  ),
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
                    bloc: registrationBlocs.registrationBloc,
                    listener: (context, state) {
                      if (state is RegisterSuccessState) {
                        Navigator.pushReplacementNamed(context, "login");
                        // Navigator
                      }
                    },
                    child: RaisedButton(
                        child: Text("Register"),
                        onPressed: () async {
                          registrationBlocs.registrationBloc.dispatch(
                              RegisterButtonPressed(
                                  username: _usernameTextEditingController.text,
                                  password: _passwordTextEditingController.text,
                                  email: _emailTextEditingController.text
                              )
                          );
                        }
                    ),
                  ),
                  RaisedButton(
                      child: Text("Login"),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "login");
                      }
                  ),
                ],
              ),
            )
        );
  }
}