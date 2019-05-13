package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class SetDisplayName extends Request {
    public SetDisplayName(Activity act, CustomResponseHandler rh, String b_displayName) {
        super(act, rh);
        Log.e("hey", "created setDisplayName object");
        body.put("displayName", b_displayName);
    }
    public void setupCall() {

        putHeaderContentType();
        putHeaderAuthToken();

        buildCall(RequestSender.getHazizzRequestTypes().setDisplayName(header, body));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
