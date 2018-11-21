package com.indeed.hazizz;

import android.content.Context;

import com.indeed.hazizz.Communication.POJO.Response.POJOauth;

public abstract class TokenManager1 {

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
    }

    public static void setRefreshToken(Context context, String newRefreshToken){
        SharedPrefs.save(context, "token", "refreshToken", newRefreshToken);
    }
}
