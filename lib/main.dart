import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/blocs/other/show_framerate_bloc.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/navigation/route_generator.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/firebase_analytics.dart';
import 'file:///C:/Users/Erik/Projects/apps/hazizz_mobile2/lib/managers/hazizz_message_handler.dart';
import 'package:native_state/native_state.dart';
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
import 'notification/notification.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';

String startPage;

ThemeData themeData;

bool newComer = false;
bool isLoggedIn = true;
bool isFromNotification = false;

String tasksTomorrowSerialized;
List<PojoTask> tasksForTomorrow;

final MainTabBlocs mainTabBlocs = MainTabBlocs();
final LoginBlocs loginBlocs = LoginBlocs();

Locale preferredLocale;

Future<bool> fromNotification() async {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  print("from notif1: ${notificationAppLaunchDetails.didNotificationLaunchApp}");
  print("from notif2: ${notificationAppLaunchDetails.payload}");
  if(notificationAppLaunchDetails.didNotificationLaunchApp) {
    isFromNotification = true;
    String payload = notificationAppLaunchDetails.payload;
    if(payload != null) {
      tasksTomorrowSerialized = payload;
    }
  }else{
  }
  return isFromNotification;
}



void main() async{
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
      if(await TokenManager.isTokenValid()) {
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
      preloaderWidget: Center(
        child: Image.asset(
          'assets/images/Logo.png',
        ),
      ),
      path: 'assets/langs',
      useOnlyLangCode: true,
      supportedLocales: supportedLocals,
      child: HazizzApp()
    ),
  ));
}

class HazizzApp extends StatefulWidget{

  const HazizzApp({Key key}) : super(key: key);

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
    else if(state == AppLifecycleState.resumed){
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

        tasksTomorrowSerialized = payload;
      }else  HazizzLogger.printLog("no payload");
      if(await fromNotification()) {
        Navigator.pushNamed(context, "/tasksTomorrow");
      }
    }

    else if(state == AppLifecycleState.detached){

    }
  }

  @override
  Widget build(BuildContext context) {
    print("startpage: $startPage");
    var savedState = SavedState.of(context);
    print("restore route: ${SavedStateRouteObserver.restoreRoute(savedState)}");
    return BlocProvider(
      create: (context) => ShowFramerateBloc(),
      child: DynamicTheme(
          data: (brightness) => themeData,
          themedWidgetBuilder: (context, theme) {
            return StyledToast(
              locale: context.locale,
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
                    isEnabled: false,
                    align: Alignment(1.0, -0.92),
                    showText: true,
                    height: 50,
                    child: Stack(
                      children: <Widget>[
                        MaterialApp(
                          navigatorKey: BusinessNavigator().navigatorKey,
                          initialRoute: startPage,
                          navigatorObservers: [
                            SavedStateRouteObserver(savedState: savedState),
                            //  FirebaseAnalyticsObserver(analytics: FirebaseAnalyticsManager.analytics),
                            FirebaseAnalyticsManager.observer
                          ],
                          onGenerateRoute: (RouteSettings routeSettings) => RouteGenerator.generateRoute(routeSettings),
                          title: localize(context, key: "hazizz_appname") ?? "Hazizz Mobile",
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