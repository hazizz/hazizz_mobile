package com.indeed.hazizz;

import android.content.Context;
import android.content.SharedPreferences;

import java.io.File;
import java.util.Set;

//import static android.app.PendingIntent.getActivity;

//SharedPreferences manager class
public class SharedPrefs {

    //SharedPreferences file name
    private static String fileName;
    private static String SHARED_PREFS_FILE_NAME = "token";
    private static Context context;

    //here you can centralize all your shared prefs keys

    //get the SharedPreferences object instance
    //create SharedPreferences file if not present

    private static void setContext(Context c){
        context = c;
    }

    private static SharedPreferences getPrefs(Context context, String fileName1) {
        fileName = fileName1;
        return context.getSharedPreferences(fileName, Context.MODE_PRIVATE);
    }

    //Save Booleans
    public static void savePref(Context context, String fileName, String key, boolean value) {
        getPrefs(context, fileName).edit().putBoolean(key, value).commit();
    }

    //Get Booleans
    public static boolean getBoolean(Context context, String fileName, String key) {
        return getPrefs(context, fileName).getBoolean(key, false);
    }

    //Get Booleans if not found return a predefined default value
    public static boolean getBoolean(Context context,String fileName, String key, boolean defaultValue) {
        return getPrefs(context, fileName).getBoolean(key, defaultValue);
    }

    //Strings
    public static void save(Context context,String fileName, String key, String value) {
        getPrefs(context, fileName).edit().putString(key, value).commit();
    }

    public static String getString(Context context,String fileName, String key) {
        return getPrefs(context, fileName).getString(key, "");
    }

    public static String getString(Context context,String fileName, String key, String defaultValue) {
        return getPrefs(context, fileName).getString(key, defaultValue);
    }

    //Integers
    public static void save(Context context,String fileName, String key, int value) {
        getPrefs(context, fileName).edit().putInt(key, value).commit();
    }

    public static int getInt(Context context,String fileName, String key) {
        return getPrefs(context, fileName).getInt(key, 0);
    }

    public static int getInt(Context context,String fileName, String key, int defaultValue) {
        return getPrefs(context, fileName).getInt(key, defaultValue);
    }

    //Floats
    public static void save(Context context,String fileName, String key, float value) {
        getPrefs(context, fileName).edit().putFloat(key, value).commit();
    }

    public static float getFloat(Context context,String fileName, String key) {
        return getPrefs(context, fileName).getFloat(key, 0);
    }

    public static float getFloat(Context context,String fileName, String key, float defaultValue) {
        return getPrefs(context, fileName).getFloat(key, defaultValue);
    }

    //Longs
    public static void save(Context context,String fileName, String key, long value) {
        getPrefs(context, fileName).edit().putLong(key, value).commit();
    }

    public static long getLong(Context context,String fileName, String key) {
        return getPrefs(context, fileName).getLong(key, 0);
    }

    public static long getLong(Context context,String fileName, String key, long defaultValue) {
        return getPrefs(context, fileName).getLong(key, defaultValue);
    }

    //StringSets
    public static void save(Context context,String fileName, String key, Set<String> value) {
        getPrefs(context, fileName).edit().putStringSet(key, value).commit();
    }

    public static Set<String> getStringSet(Context context,String fileName, String key) {
        return getPrefs(context, fileName).getStringSet(key, null);
    }

    public static Set<String> getStringSet(Context context,String fileName, String key, Set<String> defaultValue) {
        return getPrefs(context, fileName).getStringSet(key, defaultValue);
    }
}