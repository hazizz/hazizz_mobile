import 'dart:convert';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoMyDetailedInfo.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager{

  static const String _keyMe = "key_me";
  static const String _username = "username";
  static const String _displayName = "displayName";
  static const String _id = "id";
  static const String _profilePicture = "profilePicture";
  static const String _userData = "userInformation";

  static const String _userDataOld = "userData";

  static const String _seen_giveaway = "seen_giveaway";

  static PojoMeInfoPrivate meInfoOld;

  static PojoMyDetailedInfo meInfo;
  static int myId;

  static int get getMyIdSafely{
    if(meInfo != null){
      return meInfo.id;
    }
    return myId;
  }

  /*
  static Future<String> getMyUsername() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMe + _username);
  }
  */

  static void forgetMyUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    meInfo = null;
    myId = null;
    prefs.setString(_keyMe + _username, null);
    prefs.setString(_keyMe + _displayName, null);
    prefs.setInt(_keyMe + _id, null);

    prefs.setString(_keyMe + _profilePicture, null);

    setMyUserData(null);
  }

  /*
  static void setMyUsername(String myUsername) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _username, myUsername);
  }
  */

  static Future<String> getMyDisplayName() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMe + _displayName);
  }

  static void setMyDisplayName(String myDisplayName) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _displayName, myDisplayName);
  }

  /*
  static Future<int> getMyId() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int myId = prefs.getInt(_keyMe + _id);

    return myId;
  }

  static void setMyId(int userId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = userId;
    prefs.setInt(_keyMe + _id, userId);
  }
  */

  static Future<String> getMyProfilePicture() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String myPic = prefs.getString(_keyMe + _profilePicture);

    return myPic;
  }

  static void setMyProfilePicture(String base64Pic) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _profilePicture, base64Pic);
  }

  static Future<PojoMyDetailedInfo> getMyUserData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String strMyUserData = prefs.getString(_keyMe + _userData);
    HazizzLogger.printLog("strMyUserData: $strMyUserData");
    if(strMyUserData != null) {
      meInfo = PojoMyDetailedInfo.fromJson(jsonDecode(strMyUserData));
      FirebaseAnalyticsManager.setUserId(meInfo);
    }else{
      return null;
    }
    return meInfo;
  }

  static void setMyUserData(PojoMyDetailedInfo me) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(me == null){
      prefs.setString(_keyMe + _userData, null);
      return;
    }

    prefs.setString(_keyMe + _userData, jsonEncode(me));
    meInfo = me;
    myId = meInfo.id;
    FirebaseAnalyticsManager.setUserId(meInfo);
  }


  @Deprecated("This not good")
  static Future<PojoMeInfoPrivate> getMyUserDataOld() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String strMyUserData = prefs.getString(_keyMe + _userDataOld);
    HazizzLogger.printLog("strMyUserDataOld: $strMyUserData");
    if(strMyUserData != null) {
      meInfoOld = PojoMeInfoPrivate.fromJson(jsonDecode(strMyUserData));
      FirebaseAnalyticsManager.setUserId(meInfo);
    }else{
      return null;
    }
    return meInfoOld;
  }

  /*
  static void setMyUserDataOld(PojoMeInfoPrivate me) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _userDataOld, jsonEncode(me));
    meInfoOld = me;
    myId = meInfo.id;
    FirebaseAnalyticsManager.setUserId(meInfo);
  }
  */

  static Future<bool> seenGiveaway() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyMe + _seen_giveaway) == null ? false : true;
  }

  static void setSeenGiveaway() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyMe + _seen_giveaway, true);
  }
}

