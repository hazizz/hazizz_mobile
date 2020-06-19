import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/pojos/PojoAlertSettings.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/hazizz_message_handler.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/extension_methods/time_of_day_extension.dart';

class NotificationSettingsPage extends StatefulWidget {

  String getTitle(BuildContext context){
    return localize(context, key: "notification_settings");
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

  TimeOfDay newTime = TimeOfDay(hour: 0, minute: 0);

  List<DropdownMenuItem> startPageItems = List();
  List<DropdownMenuItem> supportedLocaleItems = List();



  int currentStartPageItemIndex = 0;

  bool receive = false;
  String notificationTime = "";


  bool notSaved = false;

  IconData iconBell;

  @override
  void initState() {
    RequestSender().getResponse(GetAlertSettings(qUserId: CacheManager.getMyIdSafely)).then((HazizzResponse response){
      if(response.isSuccessful){
        PojoAlertSettings alertSetting = response.convertedData;
        //   WidgetsBinding.instance.addPostFrameCallback((_){
        setState(() {
          List<String> s = alertSetting.alarmTime.split(":");
          newTime = TimeOfDay(hour: int.parse(s[0]), minute: int.parse(s[1]));
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



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "notification_settings",
      child: WillPopScope(
        onWillPop: (){
          if(notSaved){
            showHaventSavedFlushBar(context);
            return Future.value(false);
          }
          return Future.value(true);

        },
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
                    title: Text(localize(context, key: "notif_settings_notify_everyday_tasks")),
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
                          // web config
                          // await getResponse(AddFirebaseToken(pUserId: CacheManager.getMyIdSafely, bFirebaseToken: await HazizzMessageHandler().token));
                        }else{
                          setState(() {
                            iconBell = FontAwesomeIcons.solidBellSlash;
                            receive = value;
                          });
                          // web config
                          // await getResponse(RemoveFirebaseTokens(pUserId: CacheManager.getMyIdSafely, firebaseToken: await HazizzMessageHandler().token));
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
                    },
                    leading: Icon(FontAwesomeIcons.clock),
                    title: Text(localize(context, key: "set_time_for_notification")),
                    trailing: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(newTime.hazizzFormat, style: TextStyle(fontSize: 24), ),
                      ),
                      decoration: BoxDecoration(
                          color: HazizzTheme.red,
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                    )

                ),

                Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(localize(context, key: "days_0")),
                    trailing: Switch(
                      value: mondayEnabled, //!receive ? false : mondayEnabled,
                      onChanged: (value){
                        setState(() {
                          mondayEnabled = value;
                        });
                        notSaved = true;
                      }
                    )
                ),
              //  Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(localize(context, key: "days_1")),
                    trailing: Switch(
                        value: tuesdayEnabled,//!receive ? false : tuesdayEnabled,
                        onChanged: (value){
                          setState(() {
                            tuesdayEnabled = value;
                          });
                          notSaved = true;
                        }
                    )
                ),
               // Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(localize(context, key: "days_2")),
                    trailing: Switch(
                        value: wednesdayEnabled,//!receive ? false : wednesdayEnabled,
                        onChanged: (value){
                          setState(() {
                            wednesdayEnabled = value;
                          });
                          notSaved = true;
                        }
                    )
                ),
              //  Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(localize(context, key: "days_3")),
                    trailing: Switch(
                        value: thursdayEnabled,//!receive ? false : thursdayEnabled,
                        onChanged: (value){
                          setState(() {
                            thursdayEnabled = value;
                          });
                          notSaved = true;
                        }
                    )
                ),
               // Divider(),
                ListTile(
                    enabled: receive,
                    title: Text(localize(context, key: "days_4")),
                    trailing: Switch(
                        value: fridayEnabled,//!receive ? false : fridayEnabled,
                        onChanged: (value){
                          setState(() {
                            fridayEnabled = value;
                          });
                          notSaved = true;
                        }
                    )
                ),
               // Divider(),
                ListTile(
                  enabled: receive,
                  title: Text(localize(context, key: "days_5")),
                  trailing: Switch(
                    value: saturdayEnabled,//!receive ? false : saturdayEnabled,
                    onChanged: (value){
                      setState(() {
                        saturdayEnabled = value;
                      });
                      notSaved = true;
                    }
                  )
                ),
              //  Divider(),
                ListTile(
                  enabled: receive,
                  title: Text(localize(context, key: "days_6")),
                  trailing: Switch(
                    value: sundayEnabled, //!receive ? false : sundayEnabled,
                    onChanged: (value){
                      setState(() {
                        sundayEnabled = value;
                      });
                      notSaved = true;
                    }
                  )
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 12),
                  child: FloatingActionButton(
                    heroTag: "notification_settings_page",
                    child: Icon(FontAwesomeIcons.save),//Text(locText(context, key: "save")),
                    onPressed: () async {

                      DateTime now = DateTime.now();
                      String timeZoneOffset = "" ;
                      int timeZoneOffsetHour = now.timeZoneOffset.inHours;
                      if(timeZoneOffsetHour > 9){
                        timeZoneOffset += timeZoneOffsetHour.toString() + "00";
                      }else{
                        timeZoneOffset += "0" + timeZoneOffsetHour.toString() + "00";

                      }

                      String add0(int n){
                        if(n < 10){
                          return "0$n";
                        }
                        return n.toString();
                      }

                      HazizzResponse response = await RequestSender().getResponse(UpdateAlertSettings(
                        qUserId: CacheManager.getMyIdSafely, bAlarmTime: "${add0(newTime.hour)}:${add0(newTime.minute)}:00+$timeZoneOffset", bMondayEnabled: mondayEnabled,
                        bTuesdayEnabled: tuesdayEnabled, bWednesdayEnabled: wednesdayEnabled, bThursdayEnabled: thursdayEnabled,
                        bFridayEnabled: fridayEnabled, bSaturdayEnabled: saturdayEnabled, bSundayEnabled: sundayEnabled
                      ));
                      if(response.isSuccessful){
                        notSaved = false;
                      }else{
                        notSaved = true;
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
