
import 'package:flutter/material.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/kreta_login_blocs.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/dialogs/dialogs.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/widgets/kreta_login_widget.dart';

class KretaLoginPage extends StatefulWidget {

  KretaLoginPage({Key key}) : super(key: key);

  @override
  _KretaLoginPage createState() => _KretaLoginPage();
}

class _KretaLoginPage extends State<KretaLoginPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: KretaLoginWidget()
    );
  }
}
