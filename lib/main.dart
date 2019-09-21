import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:easy_localization/easy_localization_provider.dart';

import 'package:flutter/material.dart';
import 'package:mobile/hazizz_localizations.dart';
import 'package:mobile/route_generator.dart';
import 'blocs/google_login_bloc.dart';
import 'blocs/main_tab_blocs/main_tab_blocs.dart';
import 'communication/pojos/task/PojoTask.dart';
//import 'hazizz_alarm_manager.dart';
import 'custom/hazizz_logger.dart';
import 'hazizz_theme.dart';
import 'managers/token_manager.dart';
import 'managers/app_state_manager.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:dynamic_theme/dynamic_theme.dart';

import 'navigation/business_navigator.dart';
import 'notification/notification.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

String startPage;

ThemeData themeData;

bool newComer = false;

bool isLoggedIn = true;

bool isFromNotification = false;


String tasksTomorrowSerialzed;
List<PojoTask> tasksForTomorrow;

MainTabBlocs mainTabBlocs = MainTabBlocs();
LoginBlocs loginBlocs = LoginBlocs();

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;


/*
Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,

    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = await _auth.signInWithCredential(credential);
  HazizzLogger.printLog("signed in " + user.displayName);
  return user;
}
*/


Future<bool> fromNotification() async {
  var notificationAppLaunchDetails = await HazizzNotification.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if(notificationAppLaunchDetails.didNotificationLaunchApp) {
    isFromNotification = true;
    String payload = notificationAppLaunchDetails.payload;
    if(payload != null) {
      tasksTomorrowSerialzed = payload;
      //  tasksForTomorrow = getIterable(payload).map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    }
  }
  return isFromNotification;
}


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await AppState.appStartProcedure();


  themeData = await HazizzTheme.getCurrentTheme();

  if(!(await AppState.isNewComer())) {
    if(!(await AppState.isLoggedIn())) { // !(await AppState.isLoggedIn())
      isLoggedIn = false;
    }else {
      if(await TokenManager.checkIfTokenRefreshIsNeeded()) {
        await TokenManager.createTokenWithRefresh();
      }

      fromNotification();


      AppState.mainAppPartStartProcedure();


     // mainTabBlocs.initialize();
    }
  }else{
    isLoggedIn = false;
    newComer = true;
    AppState.setIsntNewComer();
  }
  runApp(EasyLocalization(child: HazizzApp()));
}

class HazizzApp extends StatefulWidget{
  @override
  _HazizzApp createState() => _HazizzApp();
}

class _HazizzApp extends State<HazizzApp> with WidgetsBindingObserver{
  Locale preferredLocale;

  DateTime currentBackPressTime;

  DateTime lastActive;

 // final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


  @override
  initState() {
    super.initState();


    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    HazizzLogger.printLog('HazizzLog: App lifecycle state is $state');

    if(state == AppLifecycleState.paused){
      lastActive = DateTime.now();
    }

    if(state == AppLifecycleState.resumed){

      if(lastActive != null){
        if(DateTime.now().difference(lastActive).inSeconds >= 60){
          MainTabBlocs().fetchAll();
        }
      }

      var notificationAppLaunchDetails = await HazizzNotification.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
        String payload = notificationAppLaunchDetails.payload;
        if(payload != null) {
          HazizzLogger.printLog("HazizzLog: payload: $payload");
          Navigator.pushNamed(context, "/tasksTomorrow");

          tasksTomorrowSerialzed = payload;
          //  tasksForTomorrow = getIterable(payload).map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
        }else  HazizzLogger.printLog("HazizzLog: no payload");




      if(await fromNotification()) {
        Navigator.pushNamed(context, "/tasksTomorrow");
      }

    }

    if(state == AppLifecycleState.suspending){

    }
  }



  @override
  Widget build(BuildContext context) {



      if(isLoggedIn){
        if(!isFromNotification){
          startPage = "/";
        }else {
          startPage = "/tasksTomorrow";
        }
      }else if(newComer){
        startPage = "intro";
      }
      else{
        startPage = "login";

       // startPage = "intro";

      }

      return new DynamicTheme(
          data: (brightness) => themeData,
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
                navigatorKey: BusinessNavigator().navigatorKey,
                title: 'Hazizz Mobile',
                showPerformanceOverlay: false,
                theme: theme,//HazizzTheme. darkThemeData,//lightThemeData,Demo Home Page'),
              initialRoute: startPage,
                // home: _startPage,//MyHomePage(title: 'Hazizz Demo Home Page') //_startPage, // MyHomePage(title: 'Hazizz
                onGenerateRoute: RouteGenerator.generateRoute,
                localizationsDelegates: [
                  HazizzLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: getSupportedLocales(),

                localeResolutionCallback: (locale, supportedLocales) {
                  // Check if the current device locale is supported
                  // Locale myLocale = Localizations.localeOf(context);


                  for(var supportedLocale in supportedLocales) {
                    if(supportedLocale.languageCode == locale.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      setPreferredLocal(supportedLocale);
                      return supportedLocale;
                    }
                  }
                  // If the locale of the device is not supported, use the first one
                  // from the list (English, in this case).
                  return supportedLocales.first;
                },
              );
          }
      );
  }
}