package com.hazizz.mobile

//import be.tramckrijte.workmanager.WorkmanagerPlugin
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
       // WorkmanagerPlugin.setPluginRegistrantCallback(this)
        FlutterFirebaseMessagingService.setPluginRegistrant(this);

        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this)

        AlarmService.setPluginRegistrant(this)
        StateRegistry.registerCallbacks(this)
       // generateKeyHash()
    }

    override fun registerWith(reg: PluginRegistry?) {
        GeneratedPluginRegistrant.registerWith(reg)
    }

    /*
    fun generateKeyHash() {
        try {
            val info = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                Log.d(">>>>>KeyHash:", Base64.encodeToString(md.digest(), Base64.DEFAULT))
            }
        } catch (e: PackageManager.NameNotFoundException) {
            Log.i(">>>>>>", e.toString())
        } catch (e: NoSuchAlgorithmException) {
            Log.i(">>>>", e.toString())
        }
    }
    */
}