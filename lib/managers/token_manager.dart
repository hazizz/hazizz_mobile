
import 'package:intl/intl.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/navigation/business_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../request_sender.dart';
import '../hazizz_response.dart';
import 'app_state_manager.dart';
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


SharedPreferences sp;

Future<SharedPreferences> getSp()async {
  if(sp == null){
    sp = await SharedPreferences.getInstance();
  }
}


class KretaAccount{
  String kretaSession;

  static const String _keyKretaUsername = "key_KretaUsername_";


  KretaAccount({@required this.kretaSession}){

  }




}


class TokenManager {

  static const String _keyToken = "key_token";
  static const String _keyRefreshToken = "key_refreshToken";
  static bool tokenIsValid = true;

  SharedPreferences prefs;



  static Future<HazizzResponse> createTokenWithPassword(@required String username, @required String password) async{
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withPassword(q_username: username, q_password: password));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;

      InfoCache.setMyUsername(username);
      setTokens(tokens.token, tokens.refresh);

    }else if(hazizzResponse.isError){
    }

    return hazizzResponse;
  }

  static Future<HazizzResponse> createTokenWithRefresh() async{
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withRefresh(q_username: await InfoCache.getMyUsername(), q_refreshToken: await getRefreshToken()));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
      setTokens(tokens.token, tokens.refresh);
    }else if(hazizzResponse.hasPojoError){
      await AppState.logout();
    }
    return hazizzResponse;
  }

  static Future<HazizzResponse> createTokenWithGoolgeOpenId(String openIdToken) async{
    HazizzResponse hazizzResponse = await RequestSender().getAuthResponse(new CreateToken.withGoogleAccount(q_openIdToken: openIdToken));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
      await setTokens(tokens.token, tokens.refresh);
      AppState.logInProcedure(tokens: tokens);
    }else if(hazizzResponse.hasPojoError){

    }
    return hazizzResponse;
  }






  static Future<bool> hasToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_keyToken);
    return !(token == null || token == "");
  }

  static Future<String> getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<String> getRefreshToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }


  static const String key_lastTokenUpdateTime = "key_lastTokenUpdateTime";

  static Future<DateTime> getLastTokenUpdateTime() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString(key_lastTokenUpdateTime);

    return DateTime.parse(str);

  }

  static Future<void> setLastTokenUpdateTime(DateTime lastTokenUpdateTime) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key_lastTokenUpdateTime, lastTokenUpdateTime.toString());
  }


  static void setTokens(String newToken, String newRefreshToken) async{
    setLastTokenUpdateTime(DateTime.now());
    setToken(newToken);
    setRefreshToken(newRefreshToken);
    HazizzLogger.printLog("tokens updated and saved");
    HazizzLogger.addKeys("token", newToken);
    HazizzLogger.addKeys("refreshToken", newRefreshToken);
  }


  static void setToken(String newToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyToken, newToken);
  }
  static void setRefreshToken(String newRefreshToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyRefreshToken, newRefreshToken);
  }

  static Future<bool> hasRefreshToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String refreshToken = prefs.getString(_keyRefreshToken);
    return !(refreshToken == null || refreshToken == "");
  }

  static const String _keyLastTokenRefreshTime = "key_LastTokenRefreshTime";
  static const String _timeFormat = "dd/MM/yyyy HH:mm:ss";

  static Future checkAndFetchTokenRefreshIfNeeded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str_lastTokenRefreshTime = prefs.getString(_keyLastTokenRefreshTime);
    if(str_lastTokenRefreshTime != null){
      DateTime lastTokenRefreshTime = DateFormat(_timeFormat).parse(_keyLastTokenRefreshTime);//DateTime.parse(str_lastTokenRefreshTime);
      if(lastTokenRefreshTime != null &&
        DateTime.now().difference(lastTokenRefreshTime).inSeconds.abs() >= 24*60*60)
      {
        createTokenWithRefresh();
      }
    }
  }

  static Future<bool> checkIfTokenRefreshIsNeeded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str_lastTokenRefreshTime = prefs.getString(_keyLastTokenRefreshTime);
    if(str_lastTokenRefreshTime != null && str_lastTokenRefreshTime != ""){
      DateTime lastTokenRefreshTime = DateFormat(_timeFormat).parse(str_lastTokenRefreshTime);//DateTime.parse(str_lastTokenRefreshTime);
      if(lastTokenRefreshTime != null &&
          DateTime.now().difference(lastTokenRefreshTime).inSeconds.abs() >= 24*60*60)
      {
        return false == false;
      }
    }
    return false;
  }

  /*
  static Future fetchToken() async {
    await fetchRefreshTokens(username: await InfoCache.getMyUsername(), refreshToken: await getRefreshToken());
  }
  */

  /*
  static Future setTokenRefreshTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastTokenRefreshTime = DateFormat(_timeFormat).format(DateTime.now());
    prefs.setString(_keyLastTokenRefreshTime, lastTokenRefreshTime);
  }
  */


  static void invalidateTokens() {
    setRefreshToken("");
    setToken("");
    tokenIsValid = false;
  }

  static bool tokenInvalidated() {
    return !tokenIsValid;
  }
}