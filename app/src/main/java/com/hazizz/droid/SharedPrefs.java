package com.hazizz.droid;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.HashMap;
import java.util.Map;
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
       // return "eyJhbGciOiJIUzUxMiJ9.eyJ1c2VybmFtZSI6ImFrb3NrYSIsInN1YiI6IkF1dGhlbnRpY2F0aW9uIHRva2VuIiwiaWF0IjoxNTQxMTAxODgwLCJleHAiOjE1NDExODgyODB9.A7Nh9qqVK-H5eFCGPpO0RQrorJcOmH1Pnnl7UtArxeuvm8sDi10lHOUDSdkxI_UwGpEcm15qR8rO80igTDZzHQ";
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

    public static class ProfileImageManager {

        static HashMap<Integer , HashMap<Integer, String>> groups = new HashMap<>();

        public static void addUsersToGroup(Context context, int groupId, HashMap<Integer, String> users){
            if(!groups.containsKey(groupId)) {
                groups.put(groupId, users);
            }
            for(Map.Entry<Integer, String> entry : users.entrySet()) {
                save(context, "group" + groupId, Integer.toString(entry.getKey()), entry.getValue());
            }
        }
        public static HashMap<Integer, String> getProfilePicsFromGroup(Context context, int groupId){
            HashMap<Integer, String> hashMap = groups.get(groupId);

            HashMap<Integer, String> returnMap =  new HashMap<>();

            for(Map.Entry<Integer, String> entry : hashMap.entrySet()){
                returnMap.put(entry.getKey(), SharedPrefs.getString(context, "group" + groupId, Integer.toString(entry.getKey())));
            }
            return returnMap;
        }
    }

    public static class TokenManager {

        // SharedPrefs.save(getContext(), "token", "token", (String) ((POJOauth)response).getToken());
        //SharedPrefs.save(getContext(), "token", "refreshToken", (String) ((POJOauth)response).getRefresh());
        private static boolean tokenIsValid = true;

        public static String getToken(Context context){
            return SharedPrefs.getString(context, "token", "token");
        }

        public static String getRefreshToken(Context context){
            return SharedPrefs.getString(context, "token", "refreshToken");

        }

        public static void setToken(Context context, String newToken){
            SharedPrefs.save(context, "token", "token", newToken);
            tokenIsValid = true;
        }

        public static void setRefreshToken(Context context, String newRefreshToken){
            SharedPrefs.save(context, "token", "refreshToken", newRefreshToken);

        }

        public static void invalidateTokens(Context context){
            setRefreshToken(context, "");
            setToken(context, "");
            tokenIsValid = false;
        }

        public static boolean tokenInvalidated(Context context){
            return !tokenIsValid;

        }

    }

    public static class ThSessionManager{
        private static final String fileName = "th_session";
        public static int getSessionId(Context context){
            return SharedPrefs.getInt(context, fileName, "sessionId");
        }

        public static void setSessionId(Context context, int sessionId){
            SharedPrefs.save(context, fileName, "sessionId", sessionId);
        }
    }

    public static class ThLoginData{
        private static final String fileName = "th_login";
        public static void setData(Context context, String username, String password, String school){
            SharedPrefs.save(context, fileName, "username", username);
            SharedPrefs.save(context, fileName, "password", password);
            SharedPrefs.save(context, fileName, "school", school);
        }

        public static void resetData(Context context){
            SharedPrefs.save(context, fileName, "username", "");
            SharedPrefs.save(context, fileName, "password", "");
            SharedPrefs.save(context, fileName, "school", "");
        }

        public static String getUsername(Context context){
            return SharedPrefs.getString(context, fileName, "username");
        }
        public static String getPassword(Context context){
            return SharedPrefs.getString(context, fileName, "password");
        }
        public static String getSchool(Context context){
            return SharedPrefs.getString(context, fileName, "school");
        }
    }


}