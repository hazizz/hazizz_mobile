import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/managers/app_state_restorer.dart';
import 'package:mobile/navigation/route_generator.dart';
import 'package:mobile/pages/settings_page/about_page.dart';
import 'package:mobile/services/hazizz_message_handler.dart';
import 'package:native_state/native_state.dart';
import 'package:shared_pref_navigation_saver/shared_pref_navigation_saver.dart';
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
import 'package:mobile/pages/kreta_pages/kreta_notes_page.dart';
import 'package:mobile/pages/kreta_pages/kreta_statistics_page.dart';
import 'package:mobile/pages/settings_page/developer_settings_page.dart';
import 'package:mobile/pages/kreta_pages/kreta_session_selector_page.dart';
import 'package:mobile/pages/settings_page/google_drive_settings_page.dart';
import 'package:mobile/pages/settings_page/kreta_settings_page.dart';
import 'package:mobile/pages/auth_pages/login_page.dart';
import 'package:mobile/pages/settings_page/logs_page.dart';
import 'package:mobile/pages/settings_page/notification_settings_page.dart';
import 'package:mobile/pages/settings_page/preferences_settings_page.dart';
import 'package:mobile/pages/tasks_page/task_calendar_page.dart';
import 'package:mobile/pages/tasks_page/view_task_page.dart';
import 'package:mobile/pages/group_pages/group_tab_hoster_page.dart';
import 'package:mobile/pages/other_pages/intro_page.dart';
import 'package:mobile/pages/kreta_pages/kreta_login_page.dart';
import 'package:mobile/pages/main_pages/main_tab_hoster_page.dart';
import 'package:mobile/pages/group_pages/my_groups_page.dart';
import 'package:mobile/pages/settings_page/profile_editor_page.dart';
import 'package:mobile/pages/settings_page/settings_page.dart';
import 'package:mobile/pages/tasks_page/task_maker_page.dart';
import 'package:mobile/pages/tasks_page/tomorrow_tasks_page.dart';



import 'dart:convert';
import 'package:json_navigation_saver/json_navigation_saver.dart';
import 'package:shared_pref_navigation_saver/shared_pref_navigation_saver.dart';
import 'package:navigation_saver/navigation_saver.dart';
import 'serializers.dart';
import 'serializers.dart';

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


  final NavigationSaver _navigatorSaver = SharedPrefNavigationSaver(
        (Iterable<RouteSettings> routes) async => json.encode(serializeRoutes(routes)),
        (String routesAsString) async => deserializeRoutes(json.decode(routesAsString)),
  );

  print("navigationrem: ${NavigationSaver.restoreRouteName}");

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
        child: HazizzApp(_navigatorSaver)
    ),
  ));
}

class HazizzApp extends StatefulWidget{

  final NavigationSaver _navigationSaver;

  const HazizzApp(this._navigationSaver, {Key key}) : super(key: key);


  @override
  _HazizzApp createState() => _HazizzApp();
}

class _HazizzApp extends State<HazizzApp> with WidgetsBindingObserver{
  DateTime currentBackPressTime;

  DateTime lastActive;




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

    if(state == AppLifecycleState.suspending){

    }
  }

  @override
  Widget build(BuildContext context) {


      print("startpage: ${startPage}");

      var savedState = SavedState.of(context);
      print("restore route: ${SavedStateRouteObserver.restoreRoute(savedState)}");

      return DynamicTheme(
            data: (brightness) => themeData,
            themedWidgetBuilder: (context, theme) {
              return MaterialApp(

                navigatorKey: BusinessNavigator().navigatorKey,
                initialRoute: startPage ??  NavigationSaver?.restoreRouteName, //?? startPage,
              //  onGenerateRoute: RouteGenerator.generateRoute,

                navigatorObservers: [widget._navigationSaver, SavedStateRouteObserver(savedState: savedState)],
                onGenerateRoute: (RouteSettings routeSettings) => widget._navigationSaver.onGenerateRoute(
                  routeSettings, (RouteSettings settings, {NextPageInfo nextPageInfo,}) => RouteGenerator.generateRoute(settings)
                  /* todo: generate your application widgets here. use `settings`, not `routeSettings` object */
                  ,
                ),



                title: locText(context, key: "hazizz_appname") ?? "Hazizz Mobile",
                showPerformanceOverlay: false,
                theme: theme,
                localizationsDelegates: [
                  HazizzLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: getSupportedLocales(),

                localeResolutionCallback: (locale, supportedLocales) {
                  print("prCode1: ${preferredLocale.toString()}");
                  if(preferredLocale != null){
                    print("prCode: ${preferredLocale.languageCode}, ${preferredLocale.countryCode}");
                    return preferredLocale;
                  }
                  for(var supportedLocale in supportedLocales) {
                    if(supportedLocale.languageCode == locale?.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      setPreferredLocale(supportedLocale);
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
              );
            }
        );
  }
}