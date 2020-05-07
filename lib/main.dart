import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
//import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/blocs/other/show_framerate_bloc.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/navigation/route_generator.dart';
import 'package:mobile/services/firebase_analytics.dart';
import 'package:mobile/services/hazizz_message_handler.dart';
import 'package:native_state/native_state.dart';
//import 'package:shared_pref_navigation_saver/shared_pref_navigation_saver.dart';
import 'package:statsfl/statsfl.dart';
import 'blocs/main_tab/main_tab_blocs.dart';
import 'communication/pojos/task/PojoTask.dart';
import 'custom/hazizz_logger.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/managers/token_manager.dart';
import 'managers/app_state_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'managers/welcome_manager.dart';
import 'navigation/business_navigator.dart';
import 'notification/notification.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'dart:convert';
//import 'package:json_navigation_saver/json_navigation_saver.dart';
//import 'package:navigation_saver/navigation_saver.dart';

String startPage;

ThemeData themeData;

bool newComer = false;

bool isLoggedIn = true;

bool isFromNotification = false;

String tasksTomorrowSerialzed;
List<PojoTask> tasksForTomorrow;

MainTabBlocs mainTabBlocs = MainTabBlocs();
LoginBlocs loginBlocs = LoginBlocs();

Locale preferredLocale;

Future<bool> fromNotification() async {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // var notificationAppLaunchDetails = await HazizzNotification.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  print("from notif1: ${notificationAppLaunchDetails.didNotificationLaunchApp}");
  print("from notif2: ${notificationAppLaunchDetails.payload}");
  if(notificationAppLaunchDetails.didNotificationLaunchApp) {
    isFromNotification = true;
    String payload = notificationAppLaunchDetails.payload;
    if(payload != null) {
      tasksTomorrowSerialzed = payload;
    }
  }else{
  }
  return isFromNotification;
}



void main() async{

  /*
  final NavigationSaver _navigatorSaver = SharedPrefNavigationSaver(
        (Iterable<RouteSettings> routes) async => json.encode(serializeRoutes(routes)),
        (String routesAsString) async => deserializeRoutes(json.decode(routesAsString)),
  );
  */

  // print("navigationrem: ${NavigationSaver.restoreRouteName}");

  WidgetsFlutterBinding.ensureInitialized();

  preferredLocale = await getPreferredLocale();

  await HazizzMessageHandler().configure();

  fromNotification();

  await AppState.appStartProcedure();

  themeData = await HazizzTheme.getCurrentTheme();

  if((await WelcomeManager.getSeenIntro()) || !(await AppState.isNewComer())) {
    if(!(await AppState.isLoggedIn())) { // !(await AppState.isLoggedIn())
      isLoggedIn = false;
    }else {
      if(await TokenManager.checkIfTokenRefreshIsNeeded()) {
        await TokenManager.createTokenWithRefresh();
      }
      AppState.mainAppPartStartProcedure();

    }
  }else{
    isLoggedIn = false;
    newComer = true;
  }

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
  }

  runApp(SavedState(
    name: "Main State",
    child: EasyLocalization(
    //  preloaderColor: Colors.lightBlueAccent ,
      preloaderWidget: Center(
        child: Image.asset(
          'assets/images/Logo.png',
        ),
      ),
      path: 'assets/langs',
     // assetLoader: FileAssetLoader(),
     //   saveLocale: true,
     // startLocale: supportedLocals[0],
     // fallbackLocale: supportedLocals[1],
      useOnlyLangCode: true,
      supportedLocales: supportedLocals,
      child: Container(
       // isEnabled: true,//PreferenceService.enabledShowFramerate,
      //  showText: true,

        child: HazizzApp()//(_navigatorSaver)
      )
    ),
  ));
}

class HazizzApp extends StatefulWidget{

 // final NavigationSaver _navigationSaver;




  const HazizzApp(/*this._navigationSaver,*/ {Key key}) : super(key: key);

  @override
  _HazizzApp createState() => _HazizzApp();
}

class _HazizzApp extends State<HazizzApp> with WidgetsBindingObserver{
  DateTime currentBackPressTime;

  DateTime lastActive;




  /*
  void enableShowFramerate(bool enabled){
    setState(() {
      showFramerate = enabled;
    });
    PreferenceService.setEnabledShowFramerate(enabled);
  }
  */
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    /*
    if(await AppStateRestorer.getShouldReloadTaskMaker()){
    TaskMakerAppState taskMakerAppState = await AppStateRestorer.loadTaskState();
    if(taskMakerAppState != null){
    if(taskMakerAppState.taskMakerMode == TaskMakerMode.create){
    startPage = "/createTask";
    }else{
    startPage = "/editTask";
    }
    }
    }
    */
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    HazizzLogger.printLog('App lifecycle state is $state');

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
        HazizzLogger.printLog("payload: $payload");
        Navigator.pushNamed(context, "/tasksTomorrow");

        tasksTomorrowSerialzed = payload;
      }else  HazizzLogger.printLog("no payload");
      if(await fromNotification()) {
        Navigator.pushNamed(context, "/tasksTomorrow");
      }
    }

    if(state == AppLifecycleState.detached){

    }
  }


  @override
  Widget build(BuildContext context) {
    print("startpage: ${startPage}");
    var savedState = SavedState.of(context);
    print("restore route: ${SavedStateRouteObserver.restoreRoute(savedState)}");
    return BlocProvider(
      create: (context) => ShowFramerateBloc(),
      child: DynamicTheme(
          data: (brightness) => themeData,
          themedWidgetBuilder: (context, theme) {
            return StyledToast(
              textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
              backgroundColor: Color(0x99000000),
              borderRadius: BorderRadius.circular(5.0),
              textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
              toastAnimation: StyledToastAnimation.fade,
              reverseAnimation: StyledToastAnimation.fade,
              curve: Curves.fastOutSlowIn,
              reverseCurve: Curves.fastLinearToSlowEaseIn,
              dismissOtherOnShow: true,
              movingOnWindowChange: true,
              child: BlocBuilder(
                bloc: context.bloc<ShowFramerateBloc>(),
                builder: (context, state){
                  bool showFramerate = false;
                  HazizzLogger.printLog("huhuhasd " + state.toString());
                  if(state is ShowFramerateEnabledState){
                    showFramerate = true;
                  }
                  return StatsFl(
                    width: 200,
                    isEnabled: false,// showFramerate,
                    align: Alignment(1.0, -0.92),
                    showText: true,
                    height: 50,
                    //   width: 300, height:1000,
                    child: Stack(
                      children: <Widget>[
                        MaterialApp(

                          navigatorKey: BusinessNavigator().navigatorKey,
                          initialRoute: startPage, //??  NavigationSaver?.restoreRouteName, //?? startPage,
                          //  onGenerateRoute: RouteGenerator.generateRoute,

                          navigatorObservers: [
                           // widget._navigationSaver,
                            SavedStateRouteObserver(savedState: savedState),
                            //  FirebaseAnalyticsObserver(analytics: FirebaseAnalyticsManager.analytics),
                            FirebaseAnalyticsManager.observer
                          ],
                          onGenerateRoute: (RouteSettings routeSettings) => RouteGenerator.generateRoute(routeSettings),
                          /*
                          onGenerateRoute: (RouteSettings routeSettings) => widget._navigationSaver.onGenerateRoute(
                            routeSettings, (RouteSettings settings, {NextPageInfo nextPageInfo,}) => RouteGenerator.generateRoute(settings),
                          ),
                          */
                          title: locText(context, key: "hazizz_appname") ?? "Hazizz Mobile",
                          showPerformanceOverlay: false,
                          theme: theme,
                          localizationsDelegates: [
                            HazizzLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                          ],
                          supportedLocales: supportedLocals,

                          localeResolutionCallback: (locale, supportedLocales) {
                            print("prCode1: ${preferredLocale.toString()}");
                            if(preferredLocale != null){
                              print("prCode: ${preferredLocale.languageCode}, ${preferredLocale.countryCode}");
                              FirebaseAnalyticsManager.setUsedLanguage(preferredLocale.languageCode);
                              return preferredLocale;
                            }
                            for(var supportedLocale in supportedLocales) {
                              if(supportedLocale.languageCode == locale?.languageCode &&
                                  supportedLocale.countryCode == locale.countryCode) {
                                setPreferredLocale(supportedLocale);
                                FirebaseAnalyticsManager.setUsedLanguage(preferredLocale.languageCode);
                                preferredLocale = supportedLocale;
                                return supportedLocale;
                              }
                            }
                            FirebaseAnalyticsManager.setUsedLanguage(preferredLocale.languageCode);
                            preferredLocale = supportedLocales.first;
                            return supportedLocales.first;
                          },
                        ),
                        if(showFramerate) PerformanceOverlay.allEnabled()
                      ],
                    )
                  );
                },
              ),
            );
          }
      ),
    );
  }
}