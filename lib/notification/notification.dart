import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:workmanager/workmanager.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/extension_methods/time_of_day_extension.dart';

Future callbackadder2() async {
  HazizzLogger.printLog("ALARM MANAGER FIRED");
  await HazizzNotification.showHazizzNotification();

}
/*
void callbackadder() {
  Workmanager.executeTask((backgroundTask)  async {
    HazizzLogger.printLog("work manager: fired");
    await HazizzNotification.showHazizzNotification();
    HazizzLogger.printLog("work manager: fired2");
    return Future.value(true);
  });
}*/

class HazizzNotification{

  static const int dailyTaskNotificationId = 1;


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
    HazizzLogger.printLog("log: notification onSelectNotification()");
  }

  static var initializationSettingsAndroid = new AndroidInitializationSettings("icon");

 // static var initializationSettingsAndroid = new AndroidInitializationSettings("@mipmap/ic_launcher");
  static var initializationSettingsIOS = new IOSInitializationSettings(
    //  onDidReceiveLocalNotification: onDidReceiveLocalNotification
  );
  static var initializationSettings = new InitializationSettings(
  initializationSettingsAndroid, initializationSettingsIOS);


  static Future showHazizzNotification() async {
    HazizzLogger.printLog("log: no its works1");

    // szombat
    if(DateTime.now().weekday == 6){
      return;
    }

    if(await getReceiveNotification()){
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      // displaying
      // az id visszajön az appba

      String tasksTomorrowChannelName = await localizeWithoutContext(key: "notification_tasksTomorrow_channel_name");
      String tasksTomorrowChannelDescription = await localizeWithoutContext(key: "notification_tasksTomorrow_channel_description");

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        tasksTomorrowChannelId, tasksTomorrowChannelName, tasksTomorrowChannelDescription,
        importance: Importance.Max,
        priority: Priority.High,
      //  color: HazizzTheme.blue,
      //  ledColor: HazizzTheme.blue,
      // icon: "ic_launcher_foreground",
        // ticker: 'ticker'
      );
      final iOSPlatformChannelSpecifics = IOSNotificationDetails();
      final platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      HazizzResponse hazizzResponse = await RequestSender().getResponse(GetTasksFromMe());

      HazizzLogger.printLog("request for notification is sent");

      if(hazizzResponse != null && hazizzResponse.isSuccessful){
        List<PojoTask> tasks = hazizzResponse.convertedData;
        if(tasks is List<PojoTask>){
          List<PojoTask> tasksToShow = List();

          for(PojoTask task in tasks) {
            if(task.dueDate.day - DateTime.now().day == 1 && !task.completed) {
              tasksToShow.add(task);
            }
          }
          if(tasksToShow.length == 0){
            await flutterLocalNotificationsPlugin.show(
              0, await localizeWithoutContext(key: "tasks_tomorrow"), "${await localizeWithoutContext(key: "no_tasks_for_tomorrow", args: [tasksToShow.length.toString()])}",
              platformChannelSpecifics,
              payload: tasksToShow.map((e) => e.toJson()).toList().toString()
            );
          }else{
            await flutterLocalNotificationsPlugin.show(
              0, await localizeWithoutContext(key: "tasks_tomorrow"), "${await localizeWithoutContext(key: "notif_unfinished_tasks", args: [tasksToShow.length.toString()])}",
              platformChannelSpecifics,
              payload: tasksToShow.map((e) => e.toJson()).toList().toString()
            );
          }


          HazizzLogger.printLog("request for notif was successful");
        }else{
          await _flutterLocalNotificationsPlugin.show(
            0, await localizeWithoutContext(key: "tasks_tomorrow"), "${await localizeWithoutContext(key: "check_your_tasks")}",
            platformChannelSpecifics,
            payload: 'none'
          );
        }
      }
      else{
        await _flutterLocalNotificationsPlugin.show(
          0, await localizeWithoutContext(key: "tasks_tomorrow"), "${await localizeWithoutContext(key: "check_your_tasks")}",
          platformChannelSpecifics,
          payload: 'none'
        );
      }
    }else{
      HazizzLogger.printLog("Alarm fired, but the notification is disabled");
    }
  }

  /*
  static void callbackadder() {
    Workmanager.executeTask((backgroundTask)  {
      HazizzLogger.printLog("log: work manager: fired");
      showHazizzNotification();
      HazizzLogger.printLog("log: work manager: fired2");
      return Future.value(true);
    });
  }
  */

  static const int hazizzNotifId = 5587346431808710000;


  static const int tasksTomorrowNotificationId = 5587346431000000000;
  static const int classesNotificationId = 5587346432;

  static Future scheduleNotificationAlarmManager({TimeOfDay timeOfDay}) async {

    if(timeOfDay == null){
      timeOfDay = await getNotificationTime();
    }
   // DateTime now = DateTime.now();
   // DateTime dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);


   // await AndroidAlarmManager.cancel(alarmID);
   // await AndroidAlarmManager.periodic(const Duration(hours: 24), alarmID, callbackadder2, wakeup: true, exact: true, rescheduleOnReboot: true,  startAt: dateTime);


    String tasksTomorrowChannelName = await localizeWithoutContext(key: "notification_tasksTomorrow_channel_name");
    String tasksTomorrowChannelDescription = await localizeWithoutContext(key: "notification_tasksTomorrow_channel_description");

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      tasksTomorrowChannelId, tasksTomorrowChannelName, tasksTomorrowChannelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      //  color: HazizzTheme.blue,
      //  ledColor: HazizzTheme.blue,
      // icon: "ic_launcher_foreground",
      // ticker: 'ticker'
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);


    Time time = new Time(timeOfDay.hour, timeOfDay.minute, 0);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      dailyTaskNotificationId,
      await localizeWithoutContext(key: "tasks_tomorrow"),
      "${await localizeWithoutContext(key: "check_your_tasks")}",
      time,
      platformChannelSpecifics,
      payload: "payload",

    );

    setNotificationTime(timeOfDay);
    HazizzLogger.printLog("log: alarm manager is set : ${timeOfDay.hour}.${timeOfDay.minute}");
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
          return  TimeOfDay(hour: 17, minute: 0);
        }
        time.add(t);
      }
      return TimeOfDay(hour: time[0], minute: time[1]);
    }else
    return TimeOfDay(hour: 17, minute: 0);
  }

  static Future cancel({int notificationId = dailyTaskNotificationId}) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
   // Workmanager.cancelByUniqueName("1");
  }

  static Future<void> setNotificationTime(TimeOfDay time) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(key_notificationTime, "${time.hour}:${time.minute}");
  }


  static const String key_receiveNotification = "key_receiveNotification";


  static void setReceiveNotification(bool receive) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(key_receiveNotification, receive);
  }
  static Future<bool> getReceiveNotification() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool receive = sp.getBool(key_receiveNotification);
    return receive == null ? false : receive;
  }


  static Future<void> showNotif(String title, String body) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      tasksTomorrowChannelId, "asd", "sad",
      importance: Importance.Max,
      priority: Priority.High,
      //  color: HazizzTheme.blue,
      //  ledColor: HazizzTheme.blue,
      // icon: "ic_launcher_foreground",
      // ticker: 'ticker'
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body,
    platformChannelSpecifics,
    payload: "paylod"
    );

  }

}
