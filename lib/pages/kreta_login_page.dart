import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hazizz_mobile/blocs/TextFormBloc.dart';
import 'package:hazizz_mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:hazizz_mobile/blocs/kreta_login_blocs.dart';
import 'package:hazizz_mobile/blocs/login_bloc.dart';
import 'package:hazizz_mobile/communication/ResponseHandler.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoTokens.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:hazizz_mobile/controller/hashed_text_controller.dart';
import 'package:hazizz_mobile/dialogs/dialogs.dart';
import 'package:hazizz_mobile/managers/TokenManager.dart';
import 'package:hazizz_mobile/managers/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import '../main.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class KretaLoginPage extends StatefulWidget {

  KretaLoginPage({Key key}) : super(key: key);

  @override
  _KretaLoginPage createState() => _KretaLoginPage();
}

class _KretaLoginPage extends State<KretaLoginPage> with SingleTickerProviderStateMixin {
  final KretaLoginPageBlocs kretaLoginPageBlocs = new KretaLoginPageBlocs();

  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController =TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    kretaLoginPageBlocs.dispose();
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    var schoolPicker = BlocBuilder(
        bloc: kretaLoginPageBlocs.schoolBloc,
        builder: (BuildContext context, ItemListState state) {
          return GestureDetector(
            child: FormField(
              builder: (FormFieldState formState) {
                return InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: HazizzTheme.formColor,
                      icon: const Icon(Icons.group),
                      labelText: 'School',
                    ),
                    child: Builder(
                      builder: (BuildContext context){//, ItemListState state) {
                        print("log: widget update2");
                        if (state is ItemListLoaded) {
                          return Container();
                        }
                        if(state is PickedSubjectState){
                          print("log: asdasdGroup: $state.item.name");
                          return Text('${state.item.name}',
                              style: TextStyle(fontSize: 24.0),
                            
                          );
                        }
                        return Text("Loading");
                      },
                    )
                );
              },
            ), //groupFormField,
            onTap: () {
              if(kretaLoginPageBlocs.schoolBloc.currentState is ItemListLoaded){
                  showDialogSchools(context, data: kretaLoginPageBlocs.schoolBloc.data,
                  onPicked: ({String key, String value}){
                    print("log: school: key: $key, value: $value");
                    kretaLoginPageBlocs.schoolBloc.dispatch(PickedEvent(item: ));
                  } 
                  );
                }
            },
          );
        }
    );
    

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
                bloc: kretaLoginPageBlocs.usernameBloc,
                builder: (BuildContext context, HFormState state) {
                  String errorText = null;
                  if (state is KretaUserNotFoundState) {
                    errorText = "No such user";
                  } else if (state is TextFormErrorTooShort) {
                    errorText = "too short mann...";
                  }
                  return TextField(
                    onChanged: (dynamic text) {
                      print("change: $text");
                      kretaLoginPageBlocs.usernameBloc.dispatch(TextFormValidate(text: text));
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
              onPressed: (){
                if(kretaLoginPageBlocs.schoolBloc.currentState is ItemListLoaded){
                  showDialogSchools(context, data: kretaLoginPageBlocs.schoolBloc.data,
                  onPicked: ({String key, String value}){
                    print("log: school: key: $key, value: $value");
                  } 
                  );
                }
              }
            ),

            BlocListener(
                bloc: kretaLoginPageBlocs.kretaLoginBloc,
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
                      kretaLoginPageBlocs.kretaLoginBloc.dispatch(
                          KretaLoginButtonPressed(
                              password: _passwordTextEditingController.text,
                              username: _usernameTextEditingController.text,
                              schoolUrl: kretaLoginPageBlocs.schoolBloc.pickedItem
                          )
                      );
                    }
                ),
            )
          ],
        ));
  }
}
