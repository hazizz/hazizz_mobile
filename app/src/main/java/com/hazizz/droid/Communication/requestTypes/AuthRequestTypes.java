package com.hazizz.droid.communication.requestTypes;

import java.util.HashMap;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.HeaderMap;
import retrofit2.http.POST;

public interface AuthRequestTypes{
    @POST("auth/accesstoken")
    Call<ResponseBody> refreshToken(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> register
    );

    @POST("auth/accesstoken")
    Call<ResponseBody> login(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> registerBody
    );

    @POST("auth/elevationtoken")
    Call<ResponseBody> elevationToken(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> newPasswordBody
    );
}

