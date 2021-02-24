import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/other/show_framerate_bloc.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/managers/hazizz_message_handler.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/server_url_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';

class DeveloperSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return localize(context, key: "developer_settings");
  }

  DeveloperSettingsPage({Key key}) : super(key: key);

  @override
  _DeveloperSettingsPage createState() => _DeveloperSettingsPage();
}

class _DeveloperSettingsPage extends State<DeveloperSettingsPage> {

  String token = "semmi";

  final TextEditingController serverUrlController = TextEditingController();

  bool _enableFramerate = false;

  bool _enableExceptionCatcher = false;

  @override
  void initState() {

    HazizzMessageHandler().token.then((token){
      setState(() {
        this.token = token;
      });
    });

    serverUrlController.text = ServerUrlManager.BASE_URL_DEFAULT;
    _enableFramerate = PreferenceManager.enabledShowFramerate;
    _enableExceptionCatcher = PreferenceManager.enabledExceptionCatcher;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: HazizzBackButton(),
          title: Text(widget.getTitle(context)),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right:8, top: 8, bottom:8),
                  child: TextField(
                    maxLines: 1,
                    controller: serverUrlController,
                    decoration: InputDecoration(labelText: localize(context, key: "server_url"),// helperText: "Oktatási azonositó",
                      alignLabelWithHint: true,
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
                        child: Text(localize(context, key: "apply")),
                        onPressed: (){
                          ServerUrlManager.setCustom(serverUrlController.text);
                        },
                      ),

                      SizedBox(width: 6,),

                      RaisedButton(
                        child: Text(localize(context, key: "reset")),
                        onPressed: (){
                          serverUrlController.text = ServerUrlManager.BASE_URL_DEFAULT;
                          ServerUrlManager.setCustom(null);
                        },
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Icon(FontAwesomeIcons.fileAlt),

                  title: Text(localize(context, key: "logs")),
                  onTap: (){
                    Navigator.pushNamed(context, "/settings/developer/logs");
                  },
                ),

                Divider(),
                ListTile(
                    leading: Icon(FontAwesomeIcons.chartBar),
                    title: Text("enable_performance_overlay".localize(context)),
                    trailing: Switch(
                      value: _enableFramerate,
                      onChanged: (val){
                        setState(() {
                          _enableFramerate = val;
                        });
                        ShowFramerateEvent event;
                        if(_enableFramerate){
                          event = ShowFramerateEnableEvent();
                        }else{
                          event = ShowFramerateDisableEvent();
                        }
                        BlocProvider.of<ShowFramerateBloc>(context).add(event);
                        PreferenceManager.setEnabledShowFramerate(_enableFramerate);
                      },
                    )
                ),
                Divider(),
                ListTile(
                    leading: Icon(FontAwesomeIcons.bug),
                    title: Text("enable_flutter_error_catcher".localize(context)),
                    trailing: Switch(
                      value: _enableExceptionCatcher,
                      onChanged: (val){
                        setState(() {
                          _enableExceptionCatcher = val;
                        });
                        PreferenceManager.setEnabledExceptionCatcher(_enableExceptionCatcher);
                      },
                    )
                ),
                Divider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.bug),
                  title: Text("caught_exceptions".localize(context)),
                  onTap: (){
                    Navigator.pushNamed(context, "/caught_exception_page");
                  },
                ),

                Divider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.times, color: Colors.red,),

                  title: Text(localize(context, key: "delete_me")),
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
                      print("oi12120: saved :$token");
                    },
                  ),
                ),
                Divider(),

                ListTile(
                  onTap: () async {
                    Navigator.pushNamed(context, "/settings/notification");
                  },
                  leading: Icon(FontAwesomeIcons.solidBell),
                  title: Text(localize(context, key: "notification_settings")),
                  // trailing: Text("time")
                ),


              ],
            ),
          ),
        )
    );
  }
}
