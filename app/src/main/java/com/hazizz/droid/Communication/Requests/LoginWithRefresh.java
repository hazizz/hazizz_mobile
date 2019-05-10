package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoAuth;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class LoginWithRefresh extends Request {
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
        PojoAuth PojoAuth = gson.fromJson(response.body().charStream(), PojoAuth.class);
        cOnResponse.onPOJOResponse(PojoAuth);
    }
}