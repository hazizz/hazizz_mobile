import 'package:shared_preferences/shared_preferences.dart';

import 'token_manager.dart';
import 'cache_manager.dart';

class AppState{

  static const key_newComer = "key_newComer";
  static const value_newComer_false = "value_newComer_false";



  static Future<bool> isLoggedIn() async {
    bool refreshToken = await TokenManager.hasRefreshToken();
    String username = await InfoCache.getMyUsername();

    bool hasUsername = username != null && username != "";
    print("log: is logged in: ${refreshToken && hasUsername}");
    return refreshToken && hasUsername;
  }


  static Future setIsntNewComer() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString(key_newComer, value_newComer_false);
  }

  static Future<bool> isNewComer() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    String newComer = sp.getString(key_newComer);
    if(newComer == value_newComer_false){
      return false;
    }
    return true;
  }




}