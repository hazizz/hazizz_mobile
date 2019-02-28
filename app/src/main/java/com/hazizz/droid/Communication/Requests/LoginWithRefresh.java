package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOauth;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class LoginWithRefresh extends Request  {
    String b_username, refreshToken;
    public LoginWithRefresh(Activity act, CustomResponseHandler rh, String b_username, String refreshToken) {
        super(act, rh);
        Log.e("hey", "created Login object");
        this.b_username = b_username;
        this.refreshToken = refreshToken;
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<>();
        headerMap.put("Content-Type", "application/json");
        body.put("username", b_username);
        body.put("refreshToken", refreshToken);
        call = aRequest.login(headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        POJOauth pojoAuth = gson.fromJson(response.body().charStream(), POJOauth.class);
        cOnResponse.onPOJOResponse(pojoAuth);
    }
}