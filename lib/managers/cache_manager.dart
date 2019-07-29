
import 'package:shared_preferences/shared_preferences.dart';

class InfoCache{

  static const String _keyMe = "key_me";
  static const String _username = "username";
  static const String _displayName = "displayName";
  static const String _id = "id";


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

  static Future<int> getMyId() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int myId = prefs.getInt(_keyMe + _id);

    return myId;
  }

  static void setMyId(int userId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyMe + _id, userId);
  }



}

