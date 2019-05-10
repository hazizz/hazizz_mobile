package com.hazizz.droid.other;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

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

    public static void clearAll(Context context, String fileName1) {
        fileName = fileName1;
        SharedPreferences.Editor editor = context.getSharedPreferences(fileName, Context.MODE_PRIVATE).edit();
        editor.clear();
        editor.apply();
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
      //  return context.getSharedPreferences(fileName, Context.MODE_PRIVATE).getLong(key, 0l);
        return getPrefs(context, fileName).getLong(key, 0);
      //  return Long.parseLong(getPrefs(context, fileName).getString(key, "0"));
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

        // SharedPrefs.save(getContext(), "token", "token", (String) ((PojoAuth)response).getToken());
        //SharedPrefs.save(getContext(), "token", "refreshToken", (String) ((PojoAuth)response).getRefresh());
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
        private static final String fileName = "th_session2";
        public static long getSessionId(Context context){
            return SharedPrefs.getLong(context, fileName, "sessionId");
        }

        public static void setSessionId(Context context, long sessionId){
            SharedPrefs.save(context, fileName, "sessionId", sessionId);
        }

        public static void clearSession(Context context){
            long nulla = 0;
            SharedPrefs.save(context, fileName, "sessionId", nulla);
        }
    }

    public static class ThLoginData{
        private static final String fileName = "th_loginData";
        public static void setData(Context context, long sessionId, String username, String school){
            String key1 = Long.toString(sessionId);
            SharedPrefs.save(context, fileName, key1 + "_" + "username", username);
            SharedPrefs.save(context, fileName, key1 + "_" + "school", school);
        }

        public static void clearData(Context context, long sessionId){
            String key1 = Long.toString(sessionId);
            SharedPrefs.save(context, Long.toString(sessionId), key1 + "_" + "username", "");
            SharedPrefs.save(context, Long.toString(sessionId), key1 + "_" + "school", "");
        }

        public static void clearAllData(Context context){

            SharedPrefs.clearAll(context, fileName);
        }

        public static String getUsername(Context context, long sessionId){
            String key1 = Long.toString(sessionId);
            return SharedPrefs.getString(context, fileName, key1 + "_" + "username");
        }
        public static String getSchool(Context context, long sessionId){
            String key1 = Long.toString(sessionId);
            return SharedPrefs.getString(context, fileName, key1 + "_" + "school");
        }



    }

    public static class Server {
        private static final String fileName = "server";
        private static final String key = "address";

        private static final String fileName_th = "server_th";

        public static String getHazizzAddress(Context context) {
            return SharedPrefs.getString(context, fileName, key) + ":8081/";
        }

        public static void setMainAddress(Context context, String address) {
            SharedPrefs.save(context, fileName, key, address);

        }

        public static boolean hasChangedAddress(Context context) {
            return SharedPrefs.getBoolean(context, fileName_th, "hasChanged");
        }

        public static void setHasChangedAddress(Context context) {
            SharedPrefs.savePref(context, fileName_th, "hasChanged", true);
        }


        public static String getTheraAddress(Context context) {
            return SharedPrefs.getString(context, fileName, key) + ":9000/thera-server/kreta/";
        }


    }

}