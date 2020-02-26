
import 'dart:convert';

import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoCache{

  static const String _keyMe = "key_me";
  static const String _username = "username";
  static const String _displayName = "displayName";
  static const String _id = "id";
  static const String _profilePicture = "profilePicture";
  static const String _userData = "userData";

  static PojoMeInfoPrivate meInfo;

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

    prefs.setString(_keyMe + _profilePicture, null);
    prefs.setString(_keyMe + _userData, null);
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
      meInfo = PojoMeInfoPrivate.fromJson(jsonDecode(str_myUserData));
    }else{
    //  HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyInfo.private());
    //  if(hazizzResponse.convertedData is PojoMeInfo){
    //    meInfo = hazizzResponse.convertedData;
    //  }
    }
    return meInfo;
  }

  static void setMyUserData(PojoMeInfoPrivate me) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    prefs.setString(_keyMe + _userData, jsonEncode(me));
    meInfo = me;
  }




}

