
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/services/hazizz_message_handler.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';

class DeveloperSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "developer_settings");
  }


  DeveloperSettingsPage({Key key}) : super(key: key);

  @override
  _DeveloperSettingsPage createState() => _DeveloperSettingsPage();
}

class _DeveloperSettingsPage extends State<DeveloperSettingsPage> with AutomaticKeepAliveClientMixin {

  String token = "semmi";

  @override
  void initState() {
    // widget.myGroupsBloc.add(FetchData());

    HazizzMessageHandler().token.then((token){
      setState(() {
        this.token = token;
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Hero(
      tag: "developer_settings",
      child: Scaffold(
          appBar: AppBar(
            leading: HazizzBackButton(),
            title: Text(widget.getTitle(context)),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.fileAlt),

                    title: Text(locText(context, key: "logs")),
                    onTap: (){
                      Navigator.pushNamed(context, "/settings/developer/logs");
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.times, color: Colors.red,),

                  title: Text(locText(context, key: "delete_me")),
                  onTap: () async {
                    await showSureToDeleteMeDialog(context);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("copy cm token"),
                  trailing: FlatButton(
                    child: Text("COPY"),
                    onPressed: (){
                      Clipboard.setData(new ClipboardData(text: token));
                      print("oi12120: saved :${token}");
                    },
                  ),
                ),
                Divider(),

              ],
            ),
          )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
