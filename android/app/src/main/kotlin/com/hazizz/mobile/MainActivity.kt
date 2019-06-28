package com.hazizz.mobile

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    /*
    //make transparent status bar
    getWindow().setStatusBarColor(0x00000000);
    GeneratedPluginRegistrant.registerWith(this);
    //Remove full screen flag after load
    ViewTreeObserver vto = getFlutterView().getViewTreeObserver()
    vto.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
      @Override
      public void onGlobalLayout() {
        getFlutterView().getViewTreeObserver().removeOnGlobalLayoutListener(this)
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
      }
    });
    */
  }
}
