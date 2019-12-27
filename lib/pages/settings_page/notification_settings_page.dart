import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/pojos/PojoAlertSettings.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/services/hazizz_message_handler.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/custom/hazizz_time_of_day.dart';

class NotificationSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return locText(context, key: "notification_settings");
  }

  NotificationSettingsPage({Key key}) : super(key: key);

  @override
  _NotificationSettingsPage createState() => _NotificationSettingsPage();
}

class _NotificationSettingsPage extends State<NotificationSettingsPage>  {

  String alarmTime;
  bool mondayEnabled = false;
  bool tuesdayEnabled = false;
  bool wednesdayEnabled = false;
  bool thursdayEnabled = false;
  bool fridayEnabled = false;
  bool saturdayEnabled = false;
  bool sundayEnabled = false;

  TimeOfDay newTime = HazizzTimeOfDay(hour: 0, minute: 0);

  List<DropdownMenuItem> startPageItems = List();
  static List<Locale> supportedLocales = getSupportedLocales();
  List<DropdownMenuItem> supportedLocaleItems = List();


  String currentLocale = supportedLocales[0].languageCode;

  int currentStartPageItemIndex = 0;

  bool receive = false;
  String notificationTime = "";

  IconData iconBell;

  @override
  void initState() {
    InfoCache.getMyUserData().then((PojoMeInfoPrivate me){
      RequestSender().getResponse(GetAlertSettings(q_userId: me.id)).then((HazizzResponse response){
        if(response.isSuccessful){
          PojoAlertSettings alertSetting = response.convertedData;
       //   WidgetsBinding.instance.addPostFrameCallback((_){
            setState(() {
              List<String> s = alertSetting.alarmTime.split(":");
              newTime = HazizzTimeOfDay(hour: int.parse(s[0]), minute: int.parse(s[1]));
              mondayEnabled = alertSetting.mondayEnabled;
              tuesdayEnabled = alertSetting.tuesdayEnabled;
              wednesdayEnabled = alertSetting.wednesdayEnabled;
              thursdayEnabled = alertSetting.thursdayEnabled;
              fridayEnabled = alertSetting.fridayEnabled;
              saturdayEnabled = alertSetting.saturdayEnabled;
              sundayEnabled = alertSetting.sundayEnabled;

              if(mondayEnabled || tuesdayEnabled || wednesdayEnabled || thursdayEnabled
              || fridayEnabled || saturdayEnabled || sundayEnabled){
                setState(() {
                  receive = true;
                });
              }
            });
        }
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListTile(
                    title: Text(locText(context, key: "notif_settings_notify_everyday_tasks")),
                    leading: Icon(iconBell),
                    trailing: Switch(
                      value: receive,
                      onChanged: (value) async {
                      //  HazizzNotification.setReceiveNotification(value);
                        if(value){
                          setState(() {
                            iconBell = FontAwesomeIcons.solidBell;
                            receive = value;
                          });

                          HazizzResponse response = await getResponse(AddFirebaseToken(userId: (await InfoCache.getMyUserData()).id, firebaseToken: await HazizzMessageHandler().token));
                        //  HazizzNotification.scheduleNotificationAlarmManager();
                        }else{
                          setState(() {
                            iconBell = FontAwesomeIcons.solidBellSlash;
                            receive = value;
                          });

                          HazizzResponse response = await getResponse(RemoveFirebaseTokens(userId: (await InfoCache.getMyUserData()).id, firebaseToken: await HazizzMessageHandler().token));
                         // HazizzNotification.cancel();
                        }
                      }
                    )
                  ),
                ),
                Divider(),
                ListTile(
                    enabled: receive,
                    onTap: () async {
                      TimeOfDay t = await showTimePicker(
                        context: context,

                        initialTime: newTime,

                      );
                      setState(() {

                        newTime = t;
                      });
                     /* if(newTime != null) {
                        HazizzNotification.scheduleNotificationAlarmManager(timeOfDay: newTime);
                        setState(() {
                          var a = HazizzTimeOfDay(hour: newTime.hour, minute: newTime.minute);
                          notificationTime = a.toHazizzFormat();

                        });
                      }
                      */
                    },
                    leading: Icon(FontAwesomeIcons.clock),
                    title: Text(locText(context, key: "set_time_for_notification")),
                    trailing: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(toHazizzFormat(newTime), style: TextStyle(fontSize: 24), ),
                      ),
                      decoration: BoxDecoration(
                          color: HazizzTheme.red,
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                    )

                ),

                /*
                Divider(),
                ListTile(
                    enabled: receive,
                   // leading: Icon(FontAwesomeIcons.clock),
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
                */


                Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(locText(context, key: "days_0")),
                    trailing: Switch(
                      value: mondayEnabled, //!receive ? false : mondayEnabled,
                      onChanged: (value){
                        setState(() {
                          mondayEnabled = value;
                        });

                      }
                    )
                ),
              //  Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(locText(context, key: "days_1")),
                    trailing: Switch(
                        value: tuesdayEnabled,//!receive ? false : tuesdayEnabled,
                        onChanged: (value){
                          setState(() {
                            tuesdayEnabled = value;
                          });

                        }
                    )
                ),
               // Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(locText(context, key: "days_2")),
                    trailing: Switch(
                        value: wednesdayEnabled,//!receive ? false : wednesdayEnabled,
                        onChanged: (value){
                          setState(() {
                            wednesdayEnabled = value;
                          });

                        }
                    )
                ),
              //  Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(locText(context, key: "days_3")),
                    trailing: Switch(
                        value: thursdayEnabled,//!receive ? false : thursdayEnabled,
                        onChanged: (value){
                          setState(() {
                            thursdayEnabled = value;
                          });

                        }
                    )
                ),
               // Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(locText(context, key: "days_4")),
                    trailing: Switch(
                        value: fridayEnabled,//!receive ? false : fridayEnabled,
                        onChanged: (value){
                          setState(() {
                            fridayEnabled = value;
                          });

                        }
                    )
                ),
               // Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(locText(context, key: "days_5")),
                    trailing: Switch(
                        value: saturdayEnabled,//!receive ? false : saturdayEnabled,
                        onChanged: (value){
                          setState(() {
                            saturdayEnabled = value;
                          });

                        }
                    )
                ),
              //  Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(locText(context, key: "days_6")),
                    trailing: Switch(
                        value: sundayEnabled, //!receive ? false : sundayEnabled,
                        onChanged: (value){
                          setState(() {
                            sundayEnabled = value;
                          });

                        }
                    )
                ),

                FlatButton(
                  child: Text(locText(context, key: "save")),
                  onPressed: () async {


                    HazizzResponse response = await RequestSender().getResponse(UpdateAlertSettings(q_userId: (await InfoCache.getMyUserData()).id, b_alarmTime: "${add0(newTime.hour)}:${add0(newTime.minute)}:00+0000", b_mondayEnabled: mondayEnabled,
                      b_tuesdayEnabled: tuesdayEnabled, b_wednesdayEnabled: wednesdayEnabled, b_thursdayEnabled: thursdayEnabled,
                      b_fridayEnabled: fridayEnabled, b_saturdayEnabled: saturdayEnabled, b_sundayEnabled: sundayEnabled
                    ));
                    if(response.isSuccessful){

                    }
                  },
                )

              ],
            ),
          ),
      ),
    );
  }
}
