package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ChangePassword extends Request {
    public ChangePassword(Activity act, CustomResponseHandler rh, String hashedNewPassword, String elevationToken) {
        super(act, rh);
        Log.e("hey", "created Me object");
        body.put("password", hashedNewPassword);
        body.put("token", elevationToken);
    }
    public void setupCall() {

        headerMap.put("Content-Type", "application/json");
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.changePassword(headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
