package com.hazizz.droid.other;

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

    public static boolean isLoggedIn(Context context){
        boolean loggedIn = SharedPrefs.getBoolean(context, fileName, "loggedIn");

        return  loggedIn;
    }

    public static void setLoggedIn(Context context, boolean loggedIn){
        SharedPrefs.savePref(context, fileName, "loggedIn", loggedIn);
    }

    public static boolean isAutoLogin(Context context){
        boolean autoLogin = SharedPrefs.getBoolean(context, fileName, "autoLogin");

        return  autoLogin;
    }

    public static void setAutoLogin(Context context, boolean autoLogin){
        SharedPrefs.savePref(context, fileName, "autoLogin", autoLogin);
    }

    public static boolean motdADayHasPassed(Context context){
        final int defaultValue = -2;
        int lastReportDay = SharedPrefs.getInt(context, fileName, "motdDate", defaultValue);
        if(lastReportDay == defaultValue){
            SharedPrefs.save(context, fileName, "motdDate", lastReportDay);
            return false;
        }
        int nowDay = D8.getDayOfYear(D8.getNow());
        if(lastReportDay == nowDay-1){
            SharedPrefs.save(context, fileName, "motdDate", lastReportDay);
            return true;
        }
        return false;
    }

    public static String getLanguage(Context context){
        return SharedPrefs.getString(context, fileName, "language", "en");
    }

    public static void setLanguage(Context context, String language_code){
        SharedPrefs.save(context, fileName, "language", language_code);
    }

}
