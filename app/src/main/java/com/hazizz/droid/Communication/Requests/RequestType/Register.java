package com.hazizz.droid.communication.requests.RequestType;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

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

        putHeaderContentType();

        buildCall(RequestSender.getHazizzRequestTypes().register(header, body));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}