import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsReporter{


  static void log(String msg){
    Crashlytics().log(msg);

  }



}