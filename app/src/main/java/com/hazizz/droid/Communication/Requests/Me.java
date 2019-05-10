package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoMe;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Me extends Request {
    public Me(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created Me object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.me(headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoMe PojoMe = gson.fromJson(response.body().charStream(), PojoMe.class);
        cOnResponse.onPOJOResponse(PojoMe);
    }
}
