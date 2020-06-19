package com.hazizz.mobile

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.androidalarmmanager.AlarmService
import com.facebook.FacebookSdk
import com.facebook.appevents.AppEventsLogger
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import nl.littlerobots.flutter.native_state.StateRegistry

class App : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this)

        AlarmService.setPluginRegistrant(this)
        StateRegistry.registerCallbacks(this)
    }

    override fun registerWith(reg: PluginRegistry?) {
        GeneratedPluginRegistrant.registerWith(reg)
    }
}

