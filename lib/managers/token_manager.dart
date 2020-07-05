import 'package:intl/intl.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'app_state_manager.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'dart:core';
import 'package:mobile/managers/firebase_analytics.dart';

class TokenManager {
  static const String _keyTokens = "key_tokens";
  static bool tokenIsValid = true;

  static PojoTokens _tokens;


  static Future<HazizzResponse> createTokenWithRefresh() async{
    HazizzLogger.printLog("In createTokenWithRefresh function");
   // HazizzLogger.printLog("In createTokenWithRefresh function0: " + (await tokens).token);
   // HazizzLogger.printLog("In createTokenWithRefresh function1: " + (await tokens).refresh);
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withRefresh(qUsername: CacheManager.meInfo.username, qRefreshToken: (await tokens).refresh));
    if(hazizzResponse.isSuccessful){
      HazizzLogger.printLog("In createTokenWithRefresh function: token response successful");
      PojoTokens tokens = hazizzResponse.convertedData;
      setTokens(tokens);
      HazizzLogger.printLog("In createTokenWithRefresh function: token is set and should be working");
    }else if(hazizzResponse.hasPojoError){
      await AppState.logout();
    }
    return hazizzResponse;
  }

  static Future<HazizzResponse> createTokenWithGoogleOpenId(String openIdToken) async{
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withGoogleAccount(qOpenIdToken: openIdToken));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
      await AppState.logInProcedure(tokens: tokens);
      FirebaseAnalyticsManager.logLogin("google");
    }else if(hazizzResponse.hasPojoError){

    }
    return hazizzResponse;
  }

  static Future<HazizzResponse> createTokenWithFacebookAccount(String facebookToken) async{
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withFacebookAccount(qFacebookToken: facebookToken));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
     // setTokens(tokens.token, tokens.refresh);
      await AppState.logInProcedure(tokens: tokens);
      FirebaseAnalyticsManager.logLogin("facebook");
    }else if(hazizzResponse.hasPojoError){

    }
    return hazizzResponse;
  }

  static const String key_lastTokenUpdateTime = "key_lastTokenUpdateTime";

  static Future<DateTime> getLastTokenUpdateTime() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString(key_lastTokenUpdateTime);
    if(str != null){
      return DateTime.parse(str);
    }
    return null;

  }

  static Future<void> setLastTokenUpdateTime(DateTime lastTokenUpdateTime) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key_lastTokenUpdateTime, lastTokenUpdateTime.toString());
  }

  
  static Future<PojoTokens> get tokens async{
    if(_tokens != null) return _tokens;

    _tokens = await getTokens();
    return _tokens;
  }

  static void setTokens(PojoTokens pojoTokens) async{
    setLastTokenUpdateTime(DateTime.now());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(pojoTokens != null){
      await prefs.setString(_keyTokens, pojoTokens.toRawJson());
      HazizzLogger.printLog("tokens updated and saved");
    }else{
      await prefs.setString(_keyTokens, null);
      HazizzLogger.printLog("token was removed");
    }
    _tokens = pojoTokens;
  }

  static Future<PojoTokens> getTokens() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String strToken = prefs.getString(_keyTokens);
    if(strToken != null && strToken != ""){
      return PojoTokens.fromRawJson(strToken);
    }
    return null;
  }

  static const String _keyLastTokenRefreshTime = "key_LastTokenRefreshTime";
  static const String _timeFormat = "dd/MM/yyyy HH:mm:ss";

  static Future<bool> isTokenValid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String strLastTokenRefreshTime = prefs.getString(_keyLastTokenRefreshTime);
    if(strLastTokenRefreshTime != null && strLastTokenRefreshTime != ""){
      DateTime lastTokenRefreshTime = DateFormat(_timeFormat).parse(strLastTokenRefreshTime);//DateTime.parse(str_lastTokenRefreshTime);
      if(lastTokenRefreshTime != null &&
          DateTime.now().difference(lastTokenRefreshTime).inSeconds.abs() >= 24*60*60)
      {
        return true;
      }
    }
    return false;
  }

  static void invalidateTokens() {
    setTokens(null);
    _tokens = null;
  }
}