import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/scheduler.dart';
<<<<<<< HEAD
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/kreta_login_blocs.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/blocs/task_maker_blocs.dart';
import 'package:mobile/communication/ResponseHandler.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/controller/hashed_text_controller.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/TokenManager.dart';
import 'package:mobile/managers/cache_manager.dart';
=======
import 'package:hazizz_mobile/blocs/TextFormBloc.dart';
import 'package:hazizz_mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:hazizz_mobile/blocs/kreta_login_blocs.dart';
import 'package:hazizz_mobile/blocs/login_bloc.dart';
import 'package:hazizz_mobile/blocs/task_maker_blocs.dart';
import 'package:hazizz_mobile/communication/ResponseHandler.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoTokens.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:hazizz_mobile/controller/hashed_text_controller.dart';
import 'package:hazizz_mobile/dialogs/dialogs.dart';
import 'package:hazizz_mobile/managers/TokenManager.dart';
import 'package:hazizz_mobile/managers/cache_manager.dart';
>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import '../hazizz_theme.dart';
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

    var usernameWidget = BlocBuilder(
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
            InputDecoration(labelText: "Kreta username", errorText: errorText),
          );
        }
    );

    var passwordWidget = BlocBuilder(
        bloc: kretaLoginPageBlocs.usernameBloc,
        builder: (BuildContext context, HFormState state) {
          String errorText = null;
          if (state is KretaUserNotFoundState) {
            errorText = "No such user";
          } else if (state is TextFormErrorTooShort) {
            errorText = "too short mann...";
          }
          return TextField(
            maxLines: 1,
            onChanged: (dynamic text) {
              print("change: $text");
              kretaLoginPageBlocs.passwordBloc.dispatch(TextFormValidate(text: text));
            },
            controller: _passwordTextEditingController,
            textInputAction: TextInputAction.next,
            decoration:
            InputDecoration(labelText: "Kreta password", errorText: errorText),
          );
        }
    );

    var schoolPickerWidget = BlocBuilder(
        bloc: kretaLoginPageBlocs.schoolBloc,
        builder: (BuildContext context, ItemListState state) {
          print("log: schoolBloc: state: ${state.toString()}");
          return GestureDetector(
            child: FormField(
              builder: (FormFieldState formState) {
                return InputDecorator(
                    decoration: InputDecoration(
                   //   filled: true,
                  //    fillColor: HazizzTheme.formColor,
                      labelText: 'School',
                    ),
                    child: Builder(
                      builder: (BuildContext context){//, ItemListState state) {
                        print("log: widget update2");
                        if (state is ItemListLoaded) {
                          return Container();
                        }
                        if(state is ItemListPickedState){
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
              if(kretaLoginPageBlocs.schoolBloc.currentState is ItemListLoaded
              || kretaLoginPageBlocs.schoolBloc.currentState is ItemListPickedState
              ){
                  showDialogSchools(context, data: kretaLoginPageBlocs.schoolBloc.data,
                  onPicked: ({String key, String value}){
                    print("log: school: key: $key, value: $value");
                    kretaLoginPageBlocs.schoolBloc.dispatch(PickedEvent(item: SchoolItem(key, value)));
                  } 
                  );
                }
            },
          );
        }
    );


    

    return Scaffold(
        body:
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/Logo.png',
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: usernameWidget,
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: passwordWidget,
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: schoolPickerWidget,
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
          ),
        )
    );
  }
}
