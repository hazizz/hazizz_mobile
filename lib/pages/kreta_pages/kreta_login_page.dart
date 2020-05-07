
import 'package:flutter/material.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/kreta_login_widget.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';

class KretaLoginPage extends StatefulWidget {

  final Function onSuccess;
  final PojoSession sessionToAuth;

  KretaLoginPage({Key key, @required this.onSuccess}) : sessionToAuth = null, super(key: key);

  KretaLoginPage.auth({Key key, @required this.sessionToAuth}) : onSuccess = null, super(key: key){
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
        appBar: AppBar(
          leading: HazizzBackButton(),
          title: Text(locText(context, key: "kreta_login")),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 0),
                child: Text(locText(context, key: "ekreta"), style: TextStyle(fontSize: 80, fontWeight: FontWeight.w800, color: HazizzTheme.blue, ),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 16),
                child: Text(locText(context, key: "login"), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: HazizzTheme.blue),),
              ),
              kretaLoginWidget
            ],
          ),
        )
    );
  }
}
