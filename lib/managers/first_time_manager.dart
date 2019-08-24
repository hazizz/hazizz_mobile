import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeManager{

  static Future getMainTasks() async {
    const key = "first_time_main_tasks";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime;
  }

  static Future getGroups() async {
    const key = "first_time_groups";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime;
  }

  static Future getSubjects() async {
    const key = "first_time_subjects";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime;
  }

  static Future getMembers() async {
    const key = "first_time_members";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime;
  }

  static Future getKretaSessions() async {
    const key = "first_time_kreta_sessions";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime;
  }


}