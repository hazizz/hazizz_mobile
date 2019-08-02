package com.hazizz.mobile;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import be.tramckrijte.workmanager.WorkmanagerPlugin;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
      //  AlarmService.setPluginRegistrant(this);
      //  WorkmanagerPlugin.setPluginRegistrantCallback(this);

     //  WorkmanagerPlugin.setPluginRegistrantCallback(this)


    }


    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);

        //   AndroidAlarmManagerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));


        //  SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));

        // FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));



        // SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));

        //  AndroidAlarmManagerPlugin.registerWith(pluginRegistry!!.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"))

    }
}
