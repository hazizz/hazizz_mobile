import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/blocs/auth/facebook_login_bloc.dart';
import 'package:mobile/blocs/auth/google_login_bloc.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/blocs/kreta/sessions_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/user_data_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/communication/connection.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/managers/server_checker.dart';
import 'package:mobile/navigation/business_navigator.dart';
import 'package:mobile/services/firebase_analytics.dart';
import 'package:mobile/storage/caches/data_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:mobile/storage/cache_manager.dart';

class AppState{
  static const key_newComer = "key_newComer";
  static const value_newComer_false = "value_newComer_false";
  static const key_isLoggedIn = "key_isLoggedIn";

  static const key_isAllowedGDrive = "key_isAllowedGDrive";

  static bool logInProcedureDone = true;

  static Future setUserData({@required PojoMeInfo meInfo}) async {
    CacheManager.setMyId(meInfo.id);
    CacheManager.setMyUsername(meInfo.username);
    CacheManager.setMyDisplayName(meInfo.displayName);

    if(meInfo is PojoMeInfoPrivate){

    }
  }

  static Future logInProcedure({@required PojoTokens tokens}) async {
    logInProcedureDone = false;

    HazizzLogger.printLog("logInProcedure: 0");
    TokenManager.setToken(tokens.access_token);
    HazizzLogger.printLog("logInProcedure: 1");

    TokenManager.setRefreshToken(tokens.refresh_token);
    HazizzLogger.printLog("logInProcedure: 2");

    var sh = await SharedPreferences.getInstance();
    sh.setBool(key_isLoggedIn, true);

    HazizzLogger.printLog("logInProcedure: 3");

  //  HazizzNotification.scheduleNotificationAlarmManager();

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
    HazizzLogger.printLog("logInProcedure: 4");

    RequestSender().getResponse(GetMyProfilePicture.full()).then((HazizzResponse hazizzResponse){
      if(hazizzResponse.isSuccessful){
        String base64Image = hazizzResponse.convertedData;
        CacheManager.setMyProfilePicture(base64Image);
      }
    });


    logInProcedureDone = true;
  }

  static Future<void> appStartProcedure() async {
    PreferenceService.loadAllPreferences();
    RequestSender().initialize();
    await HazizzAppInfo().initalize();
    await Connection.listener();
    Crashlytics.instance.enableInDevMode = false;
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
    await AndroidAlarmManager.initialize();

  }

  static Future<void> mainAppPartStartProcedure() async {

   // await TokenManager.fetchRefreshTokens(username: (await InfoCache.getMyUserData()).username, refreshToken: await TokenManager.getRefreshToken());
    Future.delayed(Duration(seconds: 2)).then((_) => ServerChecker.checkAll());
  //  RequestSender._internal();
    HazizzLogger.printLog("mainAppPartStartProcedure 1");
    await KretaSessionManager.loadSelectedSession();
    HazizzLogger.printLog("mainAppPartStartProcedure 2");
    SelectedSessionBloc().add(SelectedSessionInitalizeEvent());
    HazizzLogger.printLog("mainAppPartStartProcedure 3");
    LoginBlocs().googleLoginBloc.add(SocialLoginResetEvent());
    HazizzLogger.printLog("mainAppPartStartProcedure 4");
    MainTabBlocs().initialize();
    HazizzLogger.printLog("mainAppPartStartProcedure 5");
   // await Future.delayed(const Duration(milliseconds: 50));
    SessionsBloc().add(FetchData());
    HazizzLogger.printLog("mainAppPartStartProcedure 6");
    UserDataBlocs().initialize();
    HazizzLogger.printLog("mainAppPartStartProcedure 7");

    KretaSessionManager.getCachedSessions().then((List<PojoSession> sessions){
      FirebaseAnalyticsManager.logNumberOfKretaSessionsAdded(sessions.length);
    });
  }

  static Future logoutProcedure() async {
    RequestSender().lock();

    await GoogleLoginBloc().logout();
    await FacebookLoginBloc().logout();

    TokenManager.invalidateTokens();
    var sh = await SharedPreferences.getInstance();
    sh.setBool(key_isLoggedIn, false);
    CacheManager.forgetMyUser();
    forgetTasksCache();
    forgetScheduleCache();
    forgetGradesCache();
    setDisallowedGDrive();
    RequestSender().clearAllRequests();
    RequestSender().unlock();


  }

  static Future logout() async {
    await logoutProcedure();
    var sh = await SharedPreferences.getInstance();
    bool isLoggedIn = sh.getBool(key_isLoggedIn);
    if(!isLoggedIn){
      BusinessNavigator().state().pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
    }
  }



  static Future<bool> isLoggedIn() async {
    bool hasToken = await TokenManager.hasToken();
    bool hasRefreshToken = await TokenManager.hasRefreshToken();
    var sh = await SharedPreferences.getInstance();
    bool isLoggedIn = sh.getBool(key_isLoggedIn);
    isLoggedIn ??= false;

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


  static Future setDisallowedGDrive() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setBool(key_isAllowedGDrive, false);
  }

  static Future setAllowedGDrive() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setBool(key_isAllowedGDrive, true);
  }

  static Future<bool> isAllowedGDrive() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    bool allowed = sp.getBool(key_isAllowedGDrive);
    return allowed ?? false;
  }
}