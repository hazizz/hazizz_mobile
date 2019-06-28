import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/scheduler.dart';
<<<<<<< HEAD
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/blocs/registration_bloc.dart';
import 'package:mobile/communication/ResponseHandler.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/controller/hashed_text_controller.dart';
import 'package:mobile/managers/TokenManager.dart';
import 'package:mobile/managers/cache_manager.dart';
=======
import 'package:hazizz_mobile/blocs/TextFormBloc.dart';
import 'package:hazizz_mobile/blocs/login_bloc.dart';
import 'package:hazizz_mobile/blocs/registration_bloc.dart';
import 'package:hazizz_mobile/communication/ResponseHandler.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoTokens.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:hazizz_mobile/controller/hashed_text_controller.dart';
import 'package:hazizz_mobile/managers/TokenManager.dart';
import 'package:hazizz_mobile/managers/cache_manager.dart';
>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import '../main.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {

  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPage createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> with SingleTickerProviderStateMixin {
  final RegistrationPageBlocs registrationPageBlocs = new RegistrationPageBlocs();

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final HashedTextEditingController _passwordTextEditingController = HashedTextEditingController();


  @override
  void initState() {
    _usernameTextEditingController.addListener(
        (){
          registrationPageBlocs.usernameBloc.dispatch(TextFormValidate(text: _usernameTextEditingController.text));
        }
    );
    _emailTextEditingController.addListener(
            (){
              registrationPageBlocs.emailBloc.dispatch(TextFormValidate(text: _emailTextEditingController.text));
        }
    );
    _passwordTextEditingController.addListener(
            (){
         // registrationPageBlocs.usernameBloc.dispatch(TextFormValidate(text: _usernameTextEditingController.text));
        }
    );
    super.initState();
  }

  @override
  void dispose() {
    registrationPageBlocs.registrationBloc.dispose();
    registrationPageBlocs.usernameBloc.dispose();
    registrationPageBlocs.passwordBloc.dispose();
    _usernameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Registration"),
        ),
        body:
        SingleChildScrollView(
          child:
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/Logo.png',
              ),
              BlocBuilder(
                  bloc: registrationPageBlocs.usernameBloc,
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
                  bloc: registrationPageBlocs.emailBloc,
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
                bloc: registrationPageBlocs.registrationBloc,
                listener: (context, state) {
                  if (state is RegisterSuccessState) {
                    Navigator.pushReplacementNamed(context, "login");
                   // Navigator
                  }
                },
                child: RaisedButton(
                  child: Text("Küldés"),
                  onPressed: () async {
                    print("log: as1");
                    registrationPageBlocs.registrationBloc.dispatch(
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
        )
    );
  }
}
