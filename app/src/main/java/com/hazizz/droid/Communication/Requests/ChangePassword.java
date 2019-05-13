package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

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

        putHeaderContentType();
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().changePassword(header, body));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
