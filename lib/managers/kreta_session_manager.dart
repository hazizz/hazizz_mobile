
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/exceptions/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import 'cache_manager.dart';

class LoginError implements Exception{

}

class WrongUsernameException implements LoginError{
  @override
  String toString() => "WrongUsernameException";
}

class WrongPasswordException implements LoginError{
  @override
  String toString() => "WrongUsernameException";
}

class KretaSessionManager {

  static final String _keySession = "key_session";

//  static bool tokenIsValid = true;

  SharedPreferences prefs;

  static Future<bool> hasSession() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String session = prefs.getString(_keySession);
    return !(session == null || session == "");
  }

  /*
  static Future<List<PojoSession>> fetchSessions() async {
    dynamic responseData = await RequestSender().getResponse(new GetKretaSessions());
    if(responseData is List){
      return responseData;
    }else if(responseData is PojoError){
      int errorCode = responseData.errorCode;
      print("log: errorCode: $errorCode");
      return null;
    //  return responseData;
    }
    throw new UnexpectedResponse(responseData);
  }

  static Future<List<PojoSession>> createSession({@required String username, @required String password, @required String url}) async {
    dynamic responseData = await RequestSender().getResponse(new CreateKretaSessions(b_username: username, b_password: password, b_url: url));
    if(responseData is Response ){
      return responseData;
    }else if(responseData is PojoError){
      int errorCode = responseData.errorCode;
      print("log: errorCode: $errorCode");
      return null;
      //  return responseData;
    }
    throw new UnexpectedResponse(responseData);
  }
  */

  static Future<PojoSession> getSession() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedSession = prefs.getString(_keySession);
    Map jsonSession = json.decode(encodedSession);
    return PojoSession.fromJson(jsonSession);
  }

  static Future<void> setSession(PojoSession session) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map jsonSession = session.toJson();

    prefs.setString(_keySession, jsonSession.toString());
  }
}