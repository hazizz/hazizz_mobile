package com.hazizz.droid.Communication.requests.RequestType;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Register extends Request {
    public Register(Activity act, CustomResponseHandler rh, String b_username, String b_password, String b_emailAddress) {
        super(act, rh);
        Log.e("hey", "created");
        body.put("username", b_username);
        body.put("password", b_password);
        body.put("emailAddress", b_emailAddress);
        body.put("consent", true);
    }

    public void setupCall() {

        headerMap.put("Content-Type", "application/json");

        call = aRequest.register(headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}