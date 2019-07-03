
import 'package:intl/intl.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import '../hazizz_response.dart';
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

class TokenManager {

  static final String _keyToken = "key_token";
  static final String _keyRefreshToken = "key_refreshToken";
  static bool tokenIsValid = true;

  SharedPreferences prefs;

  static Future<bool> hasToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_keyToken);
    return !(token == null || token == "");
  }

  static Future<String> getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> fetchTokens(@required String username, @required String password) async{
    HazizzResponse hazizzResponse = await RequestSender().getResponse(new CreateTokenWithPassword(b_username: username, b_password: password));
    if(hazizzResponse.isSuccessful){
      print("log: token: tokens set");

      PojoTokens tokens = hazizzResponse.convertedData;

      InfoCache.setMyUsername(username);
      setToken(tokens.token);
      setRefreshToken(tokens.refresh);
      setTokenRefreshTime();
    }else if(hazizzResponse.isError){

      int errorCode = hazizzResponse.pojoError.errorCode;
      print("log: errorCode: $errorCode");
      if(ErrorCodes.INVALID_PASSWORD.equals(errorCode)){
        throw new WrongPasswordException();
      }else if(ErrorCodes.USER_NOT_FOUND.equals(errorCode)){
        throw new WrongUsernameException();
      }
    }
    print("log: fetch token: done");
  }

  static Future<void> fetchRefreshTokens({@required String username, @required String refreshToken}) async{
    HazizzResponse hazizzResponse = await RequestSender().getTokenResponse(new CreateTokenWithRefresh(b_username: username, b_refreshToken: refreshToken));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
      InfoCache.setMyUsername(username);
      setToken(tokens.token);
      setRefreshToken(tokens.refresh);
      setTokenRefreshTime();
    }else if(hazizzResponse.hasPojoError){
      int errorCode = hazizzResponse.pojoError.errorCode;
      if(ErrorCodes.INVALID_PASSWORD.equals(errorCode)){
        throw WrongPasswordException;
      }else if(ErrorCodes.USER_NOT_FOUND.equals(errorCode)){
        throw WrongUsernameException();
      }
    }
  }

  static Future<String> getRefreshToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
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

  static final String _keyLastTokenRefreshTime = "key_LastTokenRefreshTime";
  static final String _timeFormat = "dd/MM/yyyy HH:mm:ss";

  static Future checkAndFetchTokenRefreshIfNeeded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str_lastTokenRefreshTime = prefs.getString(_keyLastTokenRefreshTime);
    if(str_lastTokenRefreshTime != null){
      DateTime lastTokenRefreshTime = DateFormat(_timeFormat).parse(_keyLastTokenRefreshTime);//DateTime.parse(str_lastTokenRefreshTime);
      if(lastTokenRefreshTime != null &&
        DateTime.now().difference(lastTokenRefreshTime).inSeconds.abs() >= 24*60*60)
      {
        RequestSender().lock();
        fetchRefreshTokens(username: await InfoCache.getMyUsername(), refreshToken: await getRefreshToken());
        RequestSender().unlock();
      }
    }
  }

  static Future<bool> checkIfTokenRefreshIsNeeded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String str_lastTokenRefreshTime = prefs.getString(_keyLastTokenRefreshTime);
    if(str_lastTokenRefreshTime != null){
      DateTime lastTokenRefreshTime = DateFormat(_timeFormat).parse(_keyLastTokenRefreshTime);//DateTime.parse(str_lastTokenRefreshTime);
      if(lastTokenRefreshTime != null &&
          DateTime.now().difference(lastTokenRefreshTime).inSeconds.abs() >= 24*60*60)
      {
        return true;
      }
    }
    return false;
  }

  static Future fetchToken() async {
    RequestSender().lock();
    await fetchRefreshTokens(username: await InfoCache.getMyUsername(), refreshToken: await getRefreshToken());
    RequestSender().unlock();
  }

  static Future setTokenRefreshTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastTokenRefreshTime = DateFormat(_timeFormat).format(DateTime.now());
    prefs.setString(_keyLastTokenRefreshTime, lastTokenRefreshTime);
  }


  static void invalidateTokens() {
    setRefreshToken("");
    setToken("");
    tokenIsValid = false;
  }

  static bool tokenInvalidated() {
    return !tokenIsValid;
  }
}