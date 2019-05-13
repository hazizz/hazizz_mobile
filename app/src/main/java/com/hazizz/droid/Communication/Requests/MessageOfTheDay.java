package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import java.io.IOException;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class MessageOfTheDay extends Request {
    public MessageOfTheDay(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created MessageOfTheDay object");
    }

    public void setupCall() {
        buildCall(RequestSender.getHazizzRequestTypes().messageOfTheDay());
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        try {
            String r = response.body().string();
            cOnResponse.onPOJOResponse(r.substring(1, r.length() - 1));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
