package com.hazizz.droid.other;

import android.content.Context;
import android.graphics.Color;
import android.support.v4.content.ContextCompat;

import com.hazizz.droid.R;

public class Theme {

    private static final String fileName = "themeFile";

    public static boolean isDarkMode(Context context){
        boolean darkMode = SharedPrefs.getBoolean(context, fileName, "darkMode");

        return darkMode;
    }

    public static void setDarkMode(Context context, boolean isDark){
        SharedPrefs.savePref(context, fileName, "darkMode", isDark);
    }

    public static int getIconColor(Context context){
        if(isDarkMode(context)){
            return ContextCompat.getColor(context, R.color.colorIcon_dark);
        }
        return ContextCompat.getColor(context, R.color.colorIcon_light);
    }

}
