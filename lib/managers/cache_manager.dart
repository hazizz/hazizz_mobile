
import 'package:shared_preferences/shared_preferences.dart';

class InfoCache{

  static final String _keyMe = "key_me";
  static final String _username = "username";
  static final String _displayName = "displayName";

  SharedPreferences prefs;

  static Future<String> getMyUsername() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMe + _username);
  }

  static void forgetMyUsername() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMe + _username, null);
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


}

