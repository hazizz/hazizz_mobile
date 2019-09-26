import 'package:shared_preferences/shared_preferences.dart';

import '../hazizz_app_info.dart';

class VersionHandler{

  static const String _key_last_version = "key_last_version";
  static const String _key_last_buildNumber = "key_last_buildNumber";

  static void onNewVersionDetected(){

  }

  static Future<String> lastRecordedVersion() async {
    var sh = await SharedPreferences.getInstance();
    String a = sh.getString(_key_last_version);
    return a;
  }


  static Future check() async {
    String lastVersion = await lastRecordedVersion();
    String currentVersion = HazizzAppInfo().getInfo.version;

    if(currentVersion != lastVersion){
      await onNewVersionDetected();
    }

  }



}