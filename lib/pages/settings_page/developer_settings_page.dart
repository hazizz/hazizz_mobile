import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/other/show_framerate_bloc.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/services/hazizz_message_handler.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DeveloperSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "developer_settings");
  }


  DeveloperSettingsPage({Key key}) : super(key: key);

  @override
  _DeveloperSettingsPage createState() => _DeveloperSettingsPage();
}

class _DeveloperSettingsPage extends State<DeveloperSettingsPage> {

  String token = "semmi";

  final TextEditingController server_url_controller = TextEditingController();

  bool _enable_framerate = false;


  @override
  void initState() {
    // widget.myGroupsBloc.add(FetchData());

    HazizzMessageHandler().token.then((token){
      setState(() {
        this.token = token;
      });
    });

    server_url_controller.text = PreferenceService.serverUrl;

    _enable_framerate = PreferenceService.enabledShowFramerate;

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
                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right:8, top: 8, bottom:8),
                  child: TextField(
                    maxLines: 1,
                    controller: server_url_controller,
                    decoration: InputDecoration(labelText: locText(context, key: "server_url"),// helperText: "Oktatási azonositó",
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(

                      ),
                      filled: true,
                      fillColor: Colors.grey.withAlpha(120),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(locText(context, key: "apply")),
                        onPressed: (){
                          PreferenceService.setServerUrl(server_url_controller.text);
                        },
                      ),

                      SizedBox(width: 6,),

                      RaisedButton(
                        child: Text(locText(context, key: "reset")),
                        onPressed: (){
                          server_url_controller.text = Constants.BASE_URL;
                          PreferenceService.setServerUrl(Constants.BASE_URL);
                        },
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Icon(FontAwesomeIcons.fileAlt),

                  title: Text(locText(context, key: "logs")),
                  onTap: (){
                    Navigator.pushNamed(context, "/settings/developer/logs");
                  },
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

                ListTile(
                  onTap: () async {
                    Navigator.pushNamed(context, "/settings/notification");
                  },
                  leading: Icon(FontAwesomeIcons.solidBell),
                  title: Text(locText(context, key: "notification_settings")),
                  // trailing: Text("time")
                ),

                Divider(),
                ListTile(
                    leading: Icon(FontAwesomeIcons.chartBar),
                    title: Text("enable_show_framerate".locText(context)),
                    trailing: Switch(
                      value: _enable_framerate,
                      onChanged: (val){
                        setState(() {
                          _enable_framerate = val;
                        });
                        ShowFramerateEvent event;
                        if(_enable_framerate){
                          event = ShowFramerateEnableEvent();
                        }else{
                          event = ShowFramerateDisableEvent();
                        }
                        BlocProvider.of<ShowFramerateBloc>(context).add(event);
                        PreferenceService.setEnabledShowFramerate(_enable_framerate);
                      },
                    )
                ),
              ],
            ),
          )
      ),
    );
  }
}
