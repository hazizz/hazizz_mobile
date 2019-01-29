package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Feedback extends Request {
    Feedback(Context c, CustomResponseHandler rh, String b_platform, String b_version, String b_message, Object b_data) {
        super(c, rh);
        Log.e("hey", "created Feedback object");
        body.put("platform", b_platform);
        body.put("version", b_version);
        body.put("message", b_message);
        body.put("data", b_data);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        headerMap.put("Content-Type", "application/json");


        call = aRequest.feedback(headerMap, body);
        Log.e("hey", "setup call on Feedback");
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
