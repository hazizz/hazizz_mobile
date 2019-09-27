import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:mobile/widgets/kreta_session_selector_widget.dart';

class SessionSelectorPage extends StatefulWidget {

  SessionSelectorPage({Key key}) : super(key: key){
  }

  @override
  _SessionSelectorPage createState() => _SessionSelectorPage();
}

class _SessionSelectorPage extends State<SessionSelectorPage> with AutomaticKeepAliveClientMixin {
  
  @override
  void initState() {

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: HazizzBackButton(),
        title: Text(locText(context, key: "kreta_accounts")),
      ),
      body: SessionSelectorWidget()

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


