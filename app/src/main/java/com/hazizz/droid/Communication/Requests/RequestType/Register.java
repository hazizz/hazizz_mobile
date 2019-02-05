package com.hazizz.droid.Communication.Requests.RequestType;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.RequestInterface;
import com.hazizz.droid.Communication.Requests.Request;

import java.util.HashMap;

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
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Content-Type", "application/json");

        call = aRequest.register(headerMap, body);
    }
    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}