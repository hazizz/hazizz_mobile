import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class HazizzLogger{
  static String _processMessage(String msg){
    return "HazizzLog: $msg";
  }

  static void printLog(String msg){
    log(msg);
    hprint(msg);
  }

  static void hprint(String msg){
    debugPrint(_processMessage(msg));
  }

  // only logs
  static void log(String msg){
   // Crashlytics().
   // Crashlytics().log(_processMessage(msg));
  }

  static void addKeys(String key, String value){
   // Crashlytics().setString(key, value);
  }
}