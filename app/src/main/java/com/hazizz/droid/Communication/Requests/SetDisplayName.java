package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class SetDisplayName extends Request {
    public SetDisplayName(Activity act, CustomResponseHandler rh, String b_displayName) {
        super(act, rh);
        Log.e("hey", "created setDisplayName object");
        body.put("displayName", b_displayName);
    }
    public void setupCall() {

        headerMap.put("Content-Type", "application/json");
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.setDisplayName(headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
