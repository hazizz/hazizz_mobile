package com.hazizz.droid;

import android.content.Context;

public class AppInfo {

    private static final String fileName = "appInfo";

    public static boolean isFirstTimeLaunched(Context context){
        // will return false if it hasn't been set yet
        boolean firstTime = !SharedPrefs.getBoolean(context, fileName, "firstTime");
        if(firstTime){
            SharedPrefs.savePref(context, fileName, "firstTime", true);
        }
        return firstTime;
    }
}
