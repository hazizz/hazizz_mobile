package com.hazizz.droid.Communication.requests.RequestType;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoAuth;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Login extends Request  {
    String b_username, b_password;
    public Login(Activity act, CustomResponseHandler rh, String b_username, String b_password) {
        super(act, rh);
        Log.e("hey", "created Login object");
        this.b_username = b_username;
        this.b_password = b_password;
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<>();
        headerMap.put("Content-Type", "application/json");
        body.put("username", b_username);
        body.put("password", b_password);
        call = aRequest.login(headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoAuth PojoAuth = gson.fromJson(response.body().charStream(), PojoAuth.class);
        cOnResponse.onPOJOResponse(PojoAuth);
    }
}