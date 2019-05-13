package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoMe;
import com.hazizz.droid.converter.Converter;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Me extends Request {
    public Me(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created Me object");
    }
    public void setupCall() {
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().me(header));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoMe PojoMe = Converter.fromJson(response.body().charStream(), PojoMe.class);
        cOnResponse.onPOJOResponse(PojoMe);
    }
}
