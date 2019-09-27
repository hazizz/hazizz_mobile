
import 'dart:convert';

import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoCache{

  static const String _keyMe = "key_me";
  static const String _username = "username";
  static const String _displayName = "displayName";
  static const String _id = "id";
  static const String _profilePicture = "profilePicture";
  static const String _userData = "userData";


  SharedPreferences prefs;

  static Future<String> getMyUsername() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMe + _username);
  }

  static void forgetMyUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _username, null);
    prefs.setString(_keyMe + _displayName, null);
    prefs.setInt(_keyMe + _id, null);

  }

  static void setMyUsername(String myUsername) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _username, myUsername);
  }

  static Future<String> getMyDisplayName() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMe + _displayName);
  }

  static void setMyDisplayName(String myDisplayName) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _displayName, myDisplayName);
  }

  static Future<int> getMyId() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int myId = prefs.getInt(_keyMe + _id);

    return myId;
  }

  static void setMyId(int userId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyMe + _id, userId);
  }

  static Future<String> getMyProfilePicture() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String myPic = prefs.getString(_keyMe + _profilePicture);

    return myPic;
  }

  static void setMyProfilePicture(String base64Pic) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _profilePicture, base64Pic);
  }

  static Future<PojoMeInfoPrivate> getMyUserData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str_myUserData = prefs.getString(_keyMe + _userData);
    HazizzLogger.printLog("str_myUserData: $str_myUserData");
    if(str_myUserData != null) {
      PojoMeInfoPrivate meInfo = PojoMeInfoPrivate.fromJson(jsonDecode(str_myUserData));
      return meInfo;
    }else{
      return null;
    }
  }

  static void setMyUserData(PojoMeInfoPrivate meInfo) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    prefs.setString(_keyMe + _userData, jsonEncode(meInfo));
  }




}

