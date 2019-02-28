package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOme;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

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
        POJOme pojoMe = gson.fromJson(response.body().charStream(), POJOme.class);
        cOnResponse.onPOJOResponse(pojoMe);
    }
}
