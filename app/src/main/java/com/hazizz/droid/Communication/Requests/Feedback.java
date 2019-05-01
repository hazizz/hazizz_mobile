package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Feedback extends Request {
    public Feedback(Activity act, CustomResponseHandler rh, String b_platform, String b_version, String b_message) {
        super(act, rh);
        Log.e("hey", "created Feedback object");
        body.put("platform", b_platform);
        body.put("version", b_version);
        body.put("message", b_message);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put("Content-Type", "application/json");


        call = aRequest.feedback(headerMap, body);
        Log.e("hey", "setup call on Feedback");
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
