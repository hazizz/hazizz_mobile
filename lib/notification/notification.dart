import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../request_sender.dart';
import '../hazizz_alarm_manager.dart';
import '../hazizz_localizations.dart';
import '../hazizz_response.dart';

class HazizzNotification{

  static const String
  tasksTomorrowChannelName =  'Tasks for tomorrow',
  tasksTomorrowChanneDescription ='Shows your tasks for tomorrow at a given time'
  ;

  static final String tasksTomorrowChannelId = tasksTomorrowNotificationId.toString();

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  static bool isInitialized = false;
  static FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin{
    if(!isInitialized){
      _flutterLocalNotificationsPlugin.initialize(
          initializationSettings, onSelectNotification: onSelectNotification);
    }
    return _flutterLocalNotificationsPlugin;
  }

  static BuildContext context;

  bool con = false;

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    print("log: notification onSelectNotification()");
  }

  static var initializationSettingsAndroid = new AndroidInitializationSettings(
      "@mipmap/ic_launcher");
  static var initializationSettingsIOS = new IOSInitializationSettings(
    //  onDidReceiveLocalNotification: onDidReceiveLocalNotification
  );
  static var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  /*
  static Future showHazizzNotification2() async {

    while(true){
      print("log: performing work in background.");
    }
  }
  */

  static Future showHazizzNotification() async {
    print("log: no its works1");

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // displaying
    // az id visszajön az appba
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      tasksTomorrowChannelId, tasksTomorrowChannelName, tasksTomorrowChanneDescription,
      importance: Importance.Max,
      priority: Priority.High,
      // ticker: 'ticker'
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    HazizzResponse hazizzResponse = await RequestSender().getResponse(GetTasksFromMe());
    if(hazizzResponse != null && hazizzResponse.isSuccessful){
      List<PojoTask> tasks = hazizzResponse.convertedData;
      if(tasks is List<PojoTask>){
        List<PojoTask> tasksToShow = List();

        for(PojoTask task in tasks) {
          if(task.dueDate.day - DateTime
              .now()
              .day >= 1) {
            tasksToShow.add(task);
          }
        }

        await flutterLocalNotificationsPlugin.show(
          0, 'tasks:', "${await locTextContextless(key: "notif_unfinished_tasks", args: [tasksToShow.length.toString()])}",
          platformChannelSpecifics,
          payload: tasksToShow.map((e) => e.toJson()).toList().toString()
        );

        print("log: no its works2");
      }else{
        await _flutterLocalNotificationsPlugin.show(
            0, await locTextContextless(key: "tasks_tomorrow"), "${await locTextContextless(key: "check_your_homework")}",
            platformChannelSpecifics,
            payload: 'none'
        );
      }
    }
    else{
      await _flutterLocalNotificationsPlugin.show(
        0, await locTextContextless(key: "tasks_tomorrow"), "${await locTextContextless(key: "check_your_homework")}",
        platformChannelSpecifics,
        payload: 'none'
      );
    }
  }

  static const int tasksTomorrowNotificationId = 5587346431;
  static const int classesNotificationId = 5587346432;

  static Future scheduleNotificationAlarmManager(TimeOfDay timeOfDay) async {

    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

   // AndroidAlarmManager()
    bool p = await AndroidAlarmManager.periodic(
        const Duration(hours: 24, minutes: 0, ), tasksTomorrowNotificationId, showHazizzNotification,
        startAt: dateTime, rescheduleOnReboot: true, exact: true, wakeup: true);
    print("AndroidAlarmManager.periodic has been set successfully: $p");
    setNotificationTime(timeOfDay);
    print("log: alarm manager is set : ${timeOfDay.hour}.${timeOfDay.minute}");
  }

   static const String key_notificationTime = "key_notificationTime";

   static Future<TimeOfDay> getNotificationTime() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String str_time = sp.getString(key_notificationTime);
    if(str_time != null) {
      List<String> str_list_time = str_time.split(":");
      List<int> time = [];
      for(String s in str_list_time) {
        int t = int.parse(s);
        if(t == null) {
          return const TimeOfDay(hour: 17, minute: 0);
        }
        time.add(t);
      }
      return TimeOfDay(hour: time[0], minute: time[1]);
    }else
    return TimeOfDay(hour: 17, minute: 0);
  }

   static Future<void> setNotificationTime(TimeOfDay time) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(key_notificationTime, "${time.hour}:${time.minute}");
  }
}
