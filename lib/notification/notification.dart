import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';

import '../RequestSender.dart';
import '../hazizz_localizations.dart';


// android:name="io.flutter.app.FlutterApplication"

/*
<application
        android:name=".Application"
        >

    </application>
    */


class HazizzNotification{


  static Future create() async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    // displaying
    // az id visszajön az appba
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');

  }

  static Future scheduleNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

  /*
    var time = new Time(10, 0, 0);
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics,
        payload:
    );
    */
  }

  static Future<dynamic> onDidReceiveLocalNotification(int zz, String asd, String asd2, String asd3 ){
    print("log: notification onDidReceiveLocalNotification()");
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    print("log: notification onSelectNotification()");
    /*
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );
    */
  }


  static Future<List<PojoTask>> getTasksForNotification() async {
    dynamic response = await RequestSender().getResponse(GetTasksFromMe());
    if(response is List<PojoTask>){
      return response;
    }
    return response;
  }

  static Future showHazizzNotification() async {
    print("log: no its works1");
    List<PojoTask> tasks = await getTasksForNotification();
    if(tasks is List<PojoTask>) {
      List<PojoTask> tasksToShow = List();

      for(PojoTask task in tasks) {
        if(task.dueDate.day - DateTime
            .now()
            .day >= 1) {
          tasksToShow.add(task);
        }
      }

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      var initializationSettingsAndroid = new AndroidInitializationSettings(
          "@mipmap/ic_launcher");
      var initializationSettingsIOS = new IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(
          initializationSettings, onSelectNotification: onSelectNotification);

      // displaying
      // az id visszajön az appba
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.Max,
          priority: Priority.High,
          ticker: 'ticker');
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

  static final int taskNotificationId = 435853681315;

  static Future scheduleNotificationAlarmManager(DateTime when) async {
    // await AndroidAlarmManager.initialize();
    //run app
    await AndroidAlarmManager.periodic(
        const Duration(hours: 24, minutes: 1), taskNotificationId, showHazizzNotification,
        from: when, rescheduleOnReboot: true);
    print("log: alarm manager is set");
  }


}


