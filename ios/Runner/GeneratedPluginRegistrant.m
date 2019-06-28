//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <android_alarm_manager/AndroidAlarmManagerPlugin.h>
#import <connectivity/ConnectivityPlugin.h>
#import <flutter_local_notifications/FlutterLocalNotificationsPlugin.h>
#import <share/SharePlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTAndroidAlarmManagerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTAndroidAlarmManagerPlugin"]];
  [FLTConnectivityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTConnectivityPlugin"]];
  [FlutterLocalNotificationsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterLocalNotificationsPlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
}

@end
