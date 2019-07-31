import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:easy_localization/easy_localization_provider.dart';

import 'package:flutter/material.dart';
import 'package:mobile/hazizz_localizations.dart';
import 'package:mobile/route_generator.dart';
import 'blocs/main_tab_blocs/main_tab_blocs.dart';
import 'communication/connection.dart';
import 'communication/pojos/task/PojoTask.dart';
import 'hazizz_alarm_manager.dart';
import 'hazizz_theme.dart';
import 'managers/token_manager.dart';
import 'managers/app_state_manager.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:dynamic_theme/dynamic_theme.dart';

import 'notification/notification.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

String startPage;

ThemeData themeData;

bool newComer = false;

bool isLoggedIn = true;

bool isFromNotification = false;


String tasksTomorrowSerialzed;
List<PojoTask> tasksForTomorrow;

MainTabBlocs mainTabBlocs = MainTabBlocs();

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,

    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = await _auth.signInWithCredential(credential);
  print("signed in " + user.displayName);
  return user;
}

Future<void> fromDynamicLink(BuildContext context) async {
  final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
  final Uri deepLink = data?.link;

  if (deepLink != null) {
    String str_groupId =  deepLink.queryParameters["group"];
    if(str_groupId != null && str_groupId != ""){
      int groupId = int.parse(str_groupId);
      if(groupId != null){
        Navigator.pushNamed(context, "/group/groupId", arguments:groupId);
      }
    }
  }
}


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

  Connection.listener();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };


  await AndroidAlarmManager.initialize();

  themeData = await HazizzTheme.getCurrentTheme();

  if(!(await AppState.isNewComer())) {
    if(!(await AppState.isLoggedIn())) { // !(await AppState.isLoggedIn())
      isLoggedIn = false;
    }else {
      if(await TokenManager.checkIfTokenRefreshIsNeeded()) {
        await TokenManager.fetchToken();
      }

      fromNotification();


      mainTabBlocs.initialize();
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

  bool timerWentOff = false;

  @override
  initState() {
    super.initState();

    getPreferredLocal().then((locale) {
      setState(() {
        this.preferredLocale = locale;
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  
  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    print('log: state = $state');

    if(state == AppLifecycleState.resumed){


      var notificationAppLaunchDetails = await HazizzNotification.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
        String payload = notificationAppLaunchDetails.payload;
        if(payload != null) {
          print("log: payload: $payload");
          Navigator.pushNamed(context, "/tasksTomorrow");

          tasksTomorrowSerialzed = payload;
          //  tasksForTomorrow = getIterable(payload).map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
        }else  print("log: no payload");




      if(await fromNotification()) {
        Navigator.pushNamed(context, "/tasksTomorrow");
      }
      try {
        await fromDynamicLink(context);
      }catch(Ex){

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    timerWentOff = true;

      if(isLoggedIn){
        if(!isFromNotification){
          startPage = "/";
        }else {
          startPage = "/tasksTomorrow";
        }
      }else{
        startPage = "login";
      }

      return new DynamicTheme(
          data: (brightness) => themeData,
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              title: 'Hazizz Mobile',
              showPerformanceOverlay: false,
              theme: theme,//HazizzTheme. darkThemeData,//lightThemeData,
              // home: _startPage,//MyHomePage(title: 'Hazizz Demo Home Page') //_startPage, // MyHomePage(title: 'Hazizz Demo Home Page'),
              initialRoute: startPage,
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
                if(preferredLocale != null) {
                  return preferredLocale;
                }
                for(var supportedLocale in supportedLocales) {
                  if(supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
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