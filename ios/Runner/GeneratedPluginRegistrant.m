//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <android_alarm_manager/AndroidAlarmManagerPlugin.h>
#import <app_settings/AppSettingsPlugin.h>
#import <connectivity/ConnectivityPlugin.h>
#import <firebase_analytics/FirebaseAnalyticsPlugin.h>
#import <firebase_auth/FirebaseAuthPlugin.h>
#import <firebase_core/FirebaseCorePlugin.h>
#import <firebase_crashlytics/FirebaseCrashlyticsPlugin.h>
#import <firebase_dynamic_links/FirebaseDynamicLinksPlugin.h>
#import <flutter_local_notifications/FlutterLocalNotificationsPlugin.h>
#import <google_sign_in/GoogleSignInPlugin.h>
#import <intro_slider/IntroSliderPlugin.h>
#import <share/SharePlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTAndroidAlarmManagerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTAndroidAlarmManagerPlugin"]];
  [AppSettingsPlugin registerWithRegistrar:[registry registrarForPlugin:@"AppSettingsPlugin"]];
  [FLTConnectivityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTConnectivityPlugin"]];
  [FLTFirebaseAnalyticsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAnalyticsPlugin"]];
  [FLTFirebaseAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAuthPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FirebaseCrashlyticsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FirebaseCrashlyticsPlugin"]];
  [FLTFirebaseDynamicLinksPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseDynamicLinksPlugin"]];
  [FlutterLocalNotificationsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterLocalNotificationsPlugin"]];
  [FLTGoogleSignInPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTGoogleSignInPlugin"]];
  [IntroSliderPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntroSliderPlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
}

@end
