
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class NotificationSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "notification_settings");
  }

  StartPageItemPickerBloc startPageItemPickerBloc = new StartPageItemPickerBloc();

  NotificationSettingsPage({Key key}) : super(key: key);

  @override
  _NotificationSettingsPage createState() => _NotificationSettingsPage();
}

class _NotificationSettingsPage extends State<NotificationSettingsPage> with AutomaticKeepAliveClientMixin {


  List<DropdownMenuItem> startPageItems = List();
  static List<Locale> supportedLocales = getSupportedLocales();
  List<DropdownMenuItem> supportedLocaleItems = List();


  String currentLocale = supportedLocales[0].languageCode;

  int currentStartPageItemIndex = 0;


 // __NotificationSettingsPage();


  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool receive = true;
  String notificationTime = "";

  IconData iconBell;

  @override
  void initState() {
    // widget.myGroupsBloc.dispatch(FetchData());

    HazizzNotification.getReceiveNotification().then((value){
      setState(() {
        receive = value;
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
      tag: "notification_settings",
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
                    title: Text(locText(context, key: "notif_settings_notify_everyday_tasks")),
                    leading: Icon(iconBell),
                    trailing: Switch(
                      value: receive,
                      onChanged: (value){
                        HazizzNotification.setReceiveNotification(value);
                        if(value){
                          setState(() {
                            iconBell = FontAwesomeIcons.solidBell;
                            receive = value;
                          });
                        }else{
                          setState(() {
                            iconBell = FontAwesomeIcons.solidBellSlash;
                            receive = value;

                          });
                        }

                      }
                    )

                  ),
                ),
                Divider(),
                ListTile(
                    onTap: () async {
                      TimeOfDay newTime = await showTimePicker(
                        context: context,

                        initialTime: await HazizzNotification.getNotificationTime(),

                      );
                      if(newTime != null) {
                        HazizzNotification.scheduleNotificationAlarmManager(newTime);
                        setState(() {
                          var a = HazizzTimeOfDay(hour: newTime.hour, minute: newTime.minute);
                          notificationTime = a.toHazizzFormat();
                        });
                      }
                    },
                    leading: Icon(FontAwesomeIcons.clock),
                    title: Text(locText(context, key: "set_time_for_notification")),
                    trailing: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(notificationTime, style: TextStyle(fontSize: 24), ),
                      ),
                      decoration: BoxDecoration(
                          color: HazizzTheme.red,
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                    )

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
