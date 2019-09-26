
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import '../hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/blocs/settings_bloc.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

import '../hazizz_theme.dart';
import '../hazizz_time_of_day.dart';

class KretaSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "kreta_settings");
  }

  StartPageItemPickerBloc startPageItemPickerBloc = new StartPageItemPickerBloc();

  KretaSettingsPage({Key key}) : super(key: key);

  @override
  _KretaSettingsPage createState() => _KretaSettingsPage();
}

class _KretaSettingsPage extends State<KretaSettingsPage> with AutomaticKeepAliveClientMixin {


  List<DropdownMenuItem> startPageItems = List();
  static List<Locale> supportedLocales = getSupportedLocales();
  List<DropdownMenuItem> supportedLocaleItems = List();


  String currentLocale = supportedLocales[0].languageCode;

  int currentStartPageItemIndex = 0;


  // __KretaSettingsPage();


  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool isRemember = true;
  String notificationTime = "";

  IconData iconBell;

  @override
  void initState() {
    // widget.myGroupsBloc.dispatch(FetchData());

    KretaSessionManager.isRememberPassword().then((value){
      setState(() {
        isRemember = value;
        if(value){
          iconBell = FontAwesomeIcons.solidBell;
        }else{
          iconBell = FontAwesomeIcons.solidBellSlash;
        }
      });
    });

    HazizzNotification.getNotificationTime().then((value){
      setState(() {
        notificationTime = value.toHazizzFormat();
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Hero(
      tag: "kreta_settings",
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
                      title: Text(locText(context, key: "remember_kreta_password")),
                     // leading: Icon(iconBell),
                      trailing: Switch(
                          value: isRemember,
                          onChanged: (value){
                            HazizzLogger.printLog("remember kreta password is enabled: ${value}");
                            KretaSessionManager.setRememberPassword(value);
                            if(value){
                              setState(() {
                                iconBell = FontAwesomeIcons.solidBell;
                                isRemember = value;
                              });
                            }else{
                              setState(() {
                                iconBell = FontAwesomeIcons.solidBellSlash;
                                isRemember = value;

                              });
                            }

                          }
                      )

                  ),
                ),
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
