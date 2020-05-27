import 'package:intl/intl.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/services/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'app_state_manager.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'dart:core';

class TokenManager {
  static const String _keyTokens = "key_tokens";
  @Deprecated("Use instead [_keyTokens]") static const String _keyToken = "key_token";
  @Deprecated("Use instead [_keyTokens]") static const String _keyRefreshToken = "key_refreshToken";
  static bool tokenIsValid = true;

  static PojoTokens _tokens;


  static Future<HazizzResponse> createTokenWithRefresh() async{
    HazizzLogger.printLog("In createTokenWithRefresh function");
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withRefresh(q_username: await CacheManager.getMyUsername(), q_refreshToken: await getRefreshToken()));
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
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withGoogleAccount(q_openIdToken: openIdToken));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
     // setTokens(tokens);
      await AppState.logInProcedure(tokens: tokens);
      FirebaseAnalyticsManager.logLogin("google");
    }else if(hazizzResponse.hasPojoError){

    }
    return hazizzResponse;
  }

  static Future<HazizzResponse> createTokenWithFacebookAccount(String facebookToken) async{
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withFacebookAccount(q_facebookToken: facebookToken));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
     // setTokens(tokens.token, tokens.refresh);
      await AppState.logInProcedure(tokens: tokens);
      FirebaseAnalyticsManager.logLogin("facebook");
    }else if(hazizzResponse.hasPojoError){

    }
    return hazizzResponse;
  }


  @Deprecated("Use instead accessToken property")
  static Future<bool> hasToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_keyToken);
    return !(token == null || token == "");
  }

  @Deprecated("Use instead the accessToken property")
  static Future<String> getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  @Deprecated("Use instead accessToken property")
  static Future<String> getRefreshToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
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


  static Future<String> get accessToken async{
    if(_tokens != null) return _tokens.token;

    String t = (await getTokens())?.token ?? await getToken();
    return t;
  }
  
  static Future<PojoTokens> get tokens async{
    if(_tokens != null) return _tokens;

    _tokens = await getTokens();
    return _tokens;
  }

  static void setTokens(PojoTokens pojoTokens) async{
    setLastTokenUpdateTime(DateTime.now());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTokens, pojoTokens.toRawJson());
    HazizzLogger.printLog("tokens updated and saved");
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
    _setRefreshToken("");
    _setToken("");
  }

  static void _setToken(String newToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyToken, newToken);
  }
  static void _setRefreshToken(String newRefreshToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyRefreshToken, newRefreshToken);
  }

}