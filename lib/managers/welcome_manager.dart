import 'package:shared_preferences/shared_preferences.dart';

class WelcomeManager{


  static const String key_seenIntro = "first_time_intro";

  static Future<bool> getSeenIntro() async {
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key_seenIntro);
  //  sh.setBool(key, true);
    return isFirstTime == null ? true : isFirstTime;
  }

  static Future<void> haveSeenIntro() async {
    var sh = await SharedPreferences.getInstance();
   // bool isFirstTime = sh.getBool(key_seenIntro);
    sh.setBool(key_seenIntro, true);
  }

  static Future<bool> getMainTasks() async {
    const key = "first_time_main_tasks";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime == null ? true : isFirstTime;
  }

  static Future<bool> getGroups() async {
    const key = "first_time_groups";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime == null ? true : isFirstTime;
  }

  static Future<bool> getSubjects() async {
    const key = "first_time_subjects";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime == null ? true : isFirstTime;
  }

  static Future<bool> getMembers() async {
    const key = "first_time_members";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime == null ? true : isFirstTime;
  }

  static Future<bool> getKretaSessions() async {
    const key = "first_time_kreta_sessions";
    var sh = await SharedPreferences.getInstance();
    bool isFirstTime = sh.getBool(key);
    sh.setBool(key, true);
    return isFirstTime == null ? true : isFirstTime;
  }


}