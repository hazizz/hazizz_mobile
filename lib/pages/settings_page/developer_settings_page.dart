
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

  @override
  void initState() {
    // widget.myGroupsBloc.add(FetchData());

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
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(new ClipboardData(text: await HazizzMessageHandler().token));
                    print("oi12120: saved ");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,

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
