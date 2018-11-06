package com.indeed.hazizz;

import android.content.Context;

import com.indeed.hazizz.Communication.POJO.Response.POJOauth;

public abstract class TokenManager {

   // SharedPrefs.save(getContext(), "token", "token", (String) ((POJOauth)response).getToken());
    //SharedPrefs.save(getContext(), "token", "refreshToken", (String) ((POJOauth)response).getRefresh());


    public static String getToken(Context context){
        return SharedPrefs.getString(context, "token", "token");
    }

    public static String getRefreshToken(Context context){
        return SharedPrefs.getString(context, "token", "refreshToken");

    }

    public static String getUseToken(Context context){
        return SharedPrefs.getString(context, "token", "useToken");
    }

    public static void setToken(Context context, String newToken){
        SharedPrefs.save(context, "token", "token", newToken);
    }

    public static void setRefreshToken(Context context, String newRefreshToken){
        SharedPrefs.save(context, "token", "refreshToken", newRefreshToken);
    }

    public static void setUseTokenToRefresh(Context context){
        SharedPrefs.save(context, "token", "useToken", getRefreshToken(context));
        setRefreshToken(context, "");
    }

    public static void setUseTokenToAccess(Context context){
        SharedPrefs.save(context, "token", "useToken", getToken(context));
    }

}
