package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import io.flutter.plugins.share.SharePlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AndroidAlarmManagerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    SharePlugin.registerWith(registry.registrarFor("io.flutter.plugins.share.SharePlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
