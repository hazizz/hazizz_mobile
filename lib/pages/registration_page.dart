import 'dart:convert';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/blocs/registration_bloc.dart';
import 'package:mobile/controller/hashed_text_controller.dart';
import 'package:mobile/widgets/registration_widget.dart';

import '../request_sender.dart';
import '../hazizz_localizations.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/src/button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';



class RegistrationPage extends StatefulWidget {

  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPage createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Registration"),
        ),
        body:
        RegistrationWidget()
    );
  }
}