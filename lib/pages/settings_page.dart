
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/blocs/settings_bloc.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/notification/notification.dart';
import 'package:preferences/preferences.dart';

import '../hazizz_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  // This widget is the root of your application.

  String getTitle(BuildContext context){
    return locText(context, key: "settings");
  }

  StartPageItemPickerBloc startPageItemPickerBloc = new StartPageItemPickerBloc();

  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> with AutomaticKeepAliveClientMixin {

  PreferenceTitle title = PreferenceTitle("asd");

  List<DropdownMenuItem> startPageItems = List();
  static List<Locale> supportedLocales = getSupportedLocales();
  List<DropdownMenuItem> supportedLocaleItems = List();


  String currentLocale = supportedLocales[0].languageCode;

  int currentStartPageItemIndex = 0;


  _SettingsPage();


 // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
   // widget.myGroupsBloc.dispatch(FetchData());


     var initializationSettingsAndroid = new AndroidInitializationSettings(
        "@mipmap/ic_launcher");
     var initializationSettingsIOS = new IOSInitializationSettings(
      //  onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
     var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    HazizzNotification.flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: onSelectNotification);




    StartPageService.getStartPageIndex().then(
      (int value){
        setState(() {
          currentStartPageItemIndex = value;
        });
      }
    );

    super.initState();
  }


   Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

  // showTimePicker(context: context, initialTime: TimeOfDay(hour: 2, minute: 2));

    print("log: notification onSelectNotification()");

    //  await Navigator.pushNamed(context, "/settings");

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //main(key: "key");


  }

  Future showHazizzNotification() async {
    print("log: alarm2222");
  }
  /*
  static void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("log: [$now] Hello, world! isolate=${isolateId} function='$printHello'");
  }
  */

  /*
   static Future showHazizzNotification2() async {
    print("log: no its works1");

    HazizzResponse hazizzResponse = await RequestSender().getResponse(GetTasksFromMe());
    if(hazizzResponse.isSuccessful){
      List<PojoTask> tasks = hazizzResponse.convertedData;
      if(tasks is List<PojoTask>) {
        List<PojoTask> tasksToShow = List();

        for(PojoTask task in tasks) {
          if(task.dueDate.day - DateTime
              .now()
              .day >= 1) {
            tasksToShow.add(task);
          }
        }

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

        // displaying
        // az id visszajön az appba
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max,
            priority: Priority.High,
          //  ticker: 'ticker'
        );
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0, 'tasks:', "${await locTextContextless(key: "notif_unfinished_tasks", args: [tasksToShow.length.toString()])}",
            platformChannelSpecifics,
            payload: 'item x');

        print("log: no its works2");
      }
    }
    else{

      // displaying
      // az id visszajön az appba
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.Max,
          priority: Priority.High,
         // ticker: 'ticker'
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, await locTextContextless(key: "tasks_tomorrow"), "${await locTextContextless(key: "check_your_homework")}",
          platformChannelSpecifics,
          payload: 'item x');
    }

  }

  final int taskNotificationId = 435853681316;

  Future scheduleNotificationAlarmManager(TimeOfDay timeOfDay) async {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    bool p = await AndroidAlarmManager.periodic(
        const Duration(hours: 0, minutes: 1, ), taskNotificationId, showHazizzNotification2,// showHazizzNotification,
        from: dateTime, rescheduleOnReboot: true);
    print("AndroidAlarmManager.periodic: $p");


    HazizzNotification.getInstance().setNotificationTime(timeOfDay);
    print("log: alarm manager is set : ${timeOfDay.hour}.${timeOfDay.minute}");
  }

  */



  @override
  Widget build(BuildContext context) {
    print("log: redrawing");
    if(startPageItems.isEmpty) {

      List<StartPageItem> startPages = StartPageService.getStartPages(context);
      for(StartPageItem startPage in startPages) {
        startPageItems.add(DropdownMenuItem(
          value: startPage.index,
          child: Text(startPage.name,
            textAlign: TextAlign.end,
          ),
        ));
      }
    }
    if(supportedLocaleItems.isEmpty){
      supportedLocales = getSupportedLocales();
      for(Locale locale in supportedLocales) {
        print("log: locale: ${locale.countryCode}");
        supportedLocaleItems.add(DropdownMenuItem(
          value: locale.languageCode,
          child: Text(locale.countryCode,
            textAlign: TextAlign.end,
          ),
        ));
      }

    }

    print("log: $supportedLocaleItems");
    
    

    return Hero(
      tag: "settings",
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.getTitle(context)),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(locText(context, key: "startPage")),
                subtitle: Text("subbtitle"),
                trailing: DropdownButton(

                  items: startPageItems,
                  onChanged: (dynamic newStartPageIndex) async {
                    StartPageService.setStartPageIndex(newStartPageIndex);
                    setState(() {
                      currentStartPageItemIndex = newStartPageIndex;
                    });
                  },
                  value: currentStartPageItemIndex,
                ),
              ),
              Divider(),
              ListTile(
                onTap: () async {
                  print("huh2");
                  TimeOfDay newTime = await showTimePicker(
                    context: context,

                    initialTime: await HazizzNotification.getNotificationTime(),

                  );
                  if(newTime != null) {
                    HazizzNotification.scheduleNotificationAlarmManager(newTime);
                  }
                },
                title: Text(locText(context, key: "set_time_for_notification")),
                trailing: Text("time")
              ),

              ListTile(
                title: Text(locText(context, key: "startPage")),
                subtitle: Text("subbtitle"),
                trailing: DropdownButton(

                  items: supportedLocaleItems,
                  onChanged: (dynamic selectedLocale) async {
                  //  StartPageService.setStartPageIndex(newStartPageIndex);
                    print(selectedLocale);
                    setState(() {
                      currentLocale = selectedLocale;


                      this.setState(() {
                        var data = EasyLocalizationProvider.of(context).data;
                        data.changeLocale(Locale(selectedLocale.toLowerCase()));
                        print(Localizations.localeOf(context).languageCode);
                      });


                    });
                  },
                  value: currentLocale,
                ),
              ),

              ListTile(
                title: Text("go to app settings"),
                subtitle: Text("subbtitle"),
                onTap: () async {
                  await AppSettings.openAppSettings();
                },
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

