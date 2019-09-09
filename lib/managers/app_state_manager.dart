import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/blocs/google_login_bloc.dart';
import 'package:mobile/blocs/UserDataBloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/selected_session_bloc.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/hazizz_response.dart';
import 'package:mobile/navigation/business_navigator.dart';
import 'package:mobile/notification/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../hazizz_app_info.dart';
import '../request_sender.dart';
import 'kreta_session_manager.dart';
import 'token_manager.dart';
import 'cache_manager.dart';

class AppState{

  static const key_newComer = "key_newComer";
  static const value_newComer_false = "value_newComer_false";
  static const key_isLoggedIn = "key_isLoggedIn";

  static bool logInProcedureDone = true;


  static Future setUserData({@required PojoMeInfo meInfo}) async {

    InfoCache.setMyId(meInfo.id);
    InfoCache.setMyUsername(meInfo.username);
    InfoCache.setMyDisplayName(meInfo.displayName);

    if(meInfo is PojoMeInfoPrivate){

    }

  }


  static Future logInProcedure({@required PojoTokens tokens}) async {
    // set islogged in to true
    logInProcedureDone = false;

    print("log: oppoppo 1");
    TokenManager.setToken(tokens.token);
    print("log: oppoppo 1.2");

    TokenManager.setRefreshToken(tokens.refresh);
    print("log: oppoppo 2");


    var sh = await SharedPreferences.getInstance();
    sh.setBool(key_isLoggedIn, true);

    print("log: oppoppo 3");

    HazizzNotification.scheduleNotificationAlarmManager(await HazizzNotification.getNotificationTime());

    HazizzResponse hazizzResponse = await RequestSender().getResponse(GetMyInfo.private());
    if(hazizzResponse.isSuccessful){
      PojoMeInfo meInfo = hazizzResponse.convertedData;
      setUserData(meInfo: meInfo);
    }else{
      hazizzResponse = await RequestSender().getResponse(GetMyInfo.private());
      if(hazizzResponse.isSuccessful){
        PojoMeInfo meInfo = hazizzResponse.convertedData;
        setUserData(meInfo: meInfo);
      }
    }
    print("log: oppoppo 4");


    hazizzResponse = await RequestSender().getResponse(GetMyProfilePicture.full());
    if(hazizzResponse.isSuccessful){
      String base64Image = hazizzResponse.convertedData;
      InfoCache.setMyProfilePicture(base64Image);
    }

    logInProcedureDone = true;
  }


  static Future<void> appStartProcedure() async {
    RequestSender().initalize();
    await HazizzAppInfo().initalize();
    await Connection.listener();
    Crashlytics.instance.enableInDevMode = false;
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
    //await AndroidAlarmManager.initialize();


  }

  static void mainAppPartStartProcedure() async {

   // await TokenManager.fetchRefreshTokens(username: (await InfoCache.getMyUserData()).username, refreshToken: await TokenManager.getRefreshToken());


    await KretaSessionManager.loadSelectedSession();
    SelectedSessionBloc().dispatch(SelectedSessionInitalizeEvent());
    LoginBlocs().googleLoginBloc.dispatch(GoogleLoginResetEvent());
    MainTabBlocs().initialize();
    UserDataBlocs().initialize();

  }

  static Future logoutProcedure() async {
    RequestSender().clearAllRequests();

    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/userinfo.profile",
      "openid"
    ]);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });

    TokenManager.invalidateTokens();
    var sh = await SharedPreferences.getInstance();
    sh.setBool(key_isLoggedIn, false);
    InfoCache.forgetMyUser();
    RequestSender().unlock();
  }

  static void logout(){
    logoutProcedure();
    BusinessNavigator().currentState().pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  //  Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  }



  static Future<bool> isLoggedIn() async {
    bool hasToken = await TokenManager.hasToken();
    bool hasRefreshToken = await TokenManager.hasRefreshToken();
   // String username = await InfoCache.getMyUsername();
    var sh = await SharedPreferences.getInstance();
    bool isLoggedIn = sh.getBool(key_isLoggedIn);
    isLoggedIn ??= false;

  //  bool hasUsername = username != null && username != "";
 //   print("log: is logged in: ${hasRefreshToken}");
    return hasRefreshToken && isLoggedIn && hasToken;
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