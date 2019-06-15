import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hazizz_mobile/blocs/TextFormBloc.dart';
import 'package:hazizz_mobile/blocs/login_bloc.dart';
import 'package:hazizz_mobile/communication/ResponseHandler.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoTokens.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:hazizz_mobile/controller/hashed_text_controller.dart';
import 'package:hazizz_mobile/managers/TokenManager.dart';
import 'package:hazizz_mobile/managers/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import '../main.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {
  final LoginPageBlocs loginPageBlocs = new LoginPageBlocs();

  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final HashedTextEditingController _passwordTextEditingController =
      HashedTextEditingController();

  @override
  void initState() {
    FormBuilder asd = FormBuilder(child: null);

    super.initState();
  }

  @override
  void dispose() {
    loginPageBlocs.loginBloc.dispose();
    loginPageBlocs.usernameBloc.dispose();
    loginPageBlocs.passwordBloc.dispose();
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Login"),
        ),
        body:
        Column(
          children: <Widget>[
            Image.asset(
              'assets/images/Logo.png',
            ),
            BlocBuilder(
                bloc: loginPageBlocs.usernameBloc,
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
                      loginPageBlocs.usernameBloc.dispatch(TextFormValidate(text: text));
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
                bloc: loginPageBlocs.loginBloc,
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                  //  Navigator.of(context).pushNamed('/details');
                    Navigator.popAndPushNamed(context, "/");
                  }
                },
                child: RaisedButton(
                    child: Text("Küldés"),
                    onPressed: () async {
                      print("log: as1");
                      loginPageBlocs.loginBloc.dispatch(
                          LoginButtonPressedTEST(
                              password: _passwordTextEditingController.text,
                              username: _usernameTextEditingController.text
                          )
                      );
                    }
                ),
            ),
            RaisedButton(
                child: Text("Registration"),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, "registration");

                }
            ),
          ],
        ));
  }
}
