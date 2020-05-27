import 'package:mobile/managers/app_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/custom/hazizz_app_info.dart';

class VersionHandler{

  static const String _key_features_shown = "_key_features_shown";
  static const String _key_last_version = "key_last_version";
  static const String _key_last_buildNumber = "key_last_buildNumber";

  static void onNewVersionDetected(){

  }

  static Future<String> getLastRecordedVersion() async {
    var sh = await SharedPreferences.getInstance();
    String a = sh.getString(_key_last_version);
    return a;
  }

  static Future<void> setLastRecordedVersion() async {
    var sh = await SharedPreferences.getInstance();
    sh.setString(_key_last_version, HazizzAppInfo().getInfo.version);
  }

  static Future<bool> hasShowedNewFeatures() async {
    var sh = await SharedPreferences.getInstance();
    bool a = sh.getBool(_key_features_shown);
    return a;
  }

  static void setShowedNewFeatures() async {
    var sh = await SharedPreferences.getInstance();
    sh.setBool(_key_features_shown, true);
  }


  static Future check() async {
    String lastVersion = await getLastRecordedVersion();
    String currentVersion = HazizzAppInfo().getInfo.version;

    if(currentVersion != lastVersion){
      onNewVersionDetected();
    }
  }



}