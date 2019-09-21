import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'crashlytics_reporter.dart';

class HazizzLogger{

  // TODO: crashlytics keys

  static final List<String> logs = ["-----------KEYS-----------", "------------LOGS-----------"];

  static void printLog(String msg){
    log(msg);
    hprint(msg);
  }

  // only HazizzLogger.printLogs
  static void hprint(String msg){
    debugPrint(msg);
  }

  // only logs
  static void log(String msg){
    logs.add(msg);
    CrashlyticsReporter.log(msg);
  }

  static void addKeys(String key, String value){
    logs.insert(1, "$key: $value");
    Crashlytics().setString(key, value);
  }

}