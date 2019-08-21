
import 'package:flutter/material.dart';
import 'package:mobile/blocs/TextFormBloc.dart';
import 'package:mobile/blocs/item_list_picker_bloc/item_list_picker_bloc.dart';
import 'package:mobile/blocs/kreta_login_blocs.dart';
import 'package:mobile/blocs/login_bloc.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/dialogs/dialogs.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/widgets/kreta_login_widget.dart';

class KretaLoginPage extends StatefulWidget {

  Function onSuccess;
  PojoSession sessionToAuth;

  KretaLoginPage({Key key, @required this.onSuccess}) : super(key: key);

  KretaLoginPage.auth({Key key, @required this.sessionToAuth}) : super(key: key){
    auth = true;
  }

  bool auth = false;


  @override
  _KretaLoginPage createState() => _KretaLoginPage();
}

class _KretaLoginPage extends State<KretaLoginPage> with SingleTickerProviderStateMixin {

  KretaLoginWidget kretaLoginWidget;




  @override
  Widget build(BuildContext context) {
    if(widget.auth){
      kretaLoginWidget = KretaLoginWidget.auth(sessionToAuth: widget.sessionToAuth,);
    }else{
      kretaLoginWidget = KretaLoginWidget(onSuccess: widget.onSuccess,);
    }

    return Scaffold(
        body: kretaLoginWidget
    );
  }
}
