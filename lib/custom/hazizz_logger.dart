import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';


class HazizzLogger{

  // TODO: crashlytics keys

 // static final List<String> logs = ["-----------KEYS-----------", "------------LOGS-----------"];

  static String _processMessage(String msg){
    return "HazizzLog: $msg";
  }

  static void printLog(String msg){
    log(msg);
    hprint(msg);
  }

  // only HazizzLogger.printLogs
  static void hprint(String msg){
    debugPrint(_processMessage(msg));
  }

  // only logs
  static void log(String msg){
   // logs.add(_processMessage(msg));
    Crashlytics().log(_processMessage(msg));
  }

  static void addKeys(String key, String value){
  //  logs.insert(1, "$key: $value");
   // hprint("$key: $value");
    Crashlytics().setString(key, value);
  }
}