import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:intro_slider/intro_slider.dart";
import 'package:intro_slider/slide_object.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/kreta_login_blocs.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/controller/hashed_text_controller.dart';
import 'package:mobile/dialogs/dialogs.dart';

import '../hazizz_localizations.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/registration_bloc.dart';


import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';



class IntroPage extends StatefulWidget {

  String getTabName(BuildContext context){
    return locText(context, key: "subjects");
  }

  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPage createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{


  TabController _tabController;

  List<Widget> slides;

  void _handleTabSelection() {
    setState(() {

    });
  }

  @override
  void initState() {

    slides = [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("What is Hazizz?"),

          ],
        )
      ),
      Builder(
          builder: (BuildContext context){

            final RegistrationPageBlocs registrationPageBlocs = new RegistrationPageBlocs();

            final TextEditingController _usernameTextEditingController = TextEditingController();
            final TextEditingController _emailTextEditingController = TextEditingController();
            final HashedTextEditingController _passwordTextEditingController = HashedTextEditingController();

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[


                  Center(
                    child: Text("Sign in to"),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/Logo.png',
                    ),
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

                  GoogleSignInButton(
                    text: locText(context, key: "sign_in_google"),
                    onPressed: (){
                      print("log: pressed google button");
                    },
                    darkMode: true,
                  ),
                ],
              ),
            );

          }
      ),
      Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Kréta"),

            ],
          )
      ),
      Builder(
        builder: (BuildContext context){

          final KretaLoginPageBlocs kretaLoginPageBlocs = new KretaLoginPageBlocs();

          final TextEditingController _usernameTextEditingController = TextEditingController();
          final TextEditingController _passwordTextEditingController =TextEditingController();

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
                      showSchoolsDialog(context, data: kretaLoginPageBlocs.schoolBloc.data,
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


          return Column(
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
                );
        }
      )
    ];

    _tabController = new TabController(length: slides.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(

          physics: ClampingScrollPhysics(),
          controller: _tabController,
          children: slides,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


