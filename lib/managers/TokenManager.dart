import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {

  static final String _keyToken = "key_token";
  static final String _keyRefreshToken = "key_refreshToken";
  static bool tokenIsValid = true;

  SharedPreferences prefs;

  static Future<bool> hasToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_keyToken);
    return (token != null && token != "");
  }

  static Future<String> getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
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

  static void invalidateTokens() {
    setRefreshToken("");
    setToken("");
    tokenIsValid = false;
  }

  static bool tokenInvalidated() {
    return !tokenIsValid;
  }
}