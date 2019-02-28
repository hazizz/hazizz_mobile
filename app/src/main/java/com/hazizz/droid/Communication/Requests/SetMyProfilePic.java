package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class SetMyProfilePic extends Request {
    public SetMyProfilePic(Activity act, CustomResponseHandler rh, String b_data, String b_type) {
        super(act, rh);
        Log.e("hey", "created GetMyProfilePic object");
        String finalString = b_data.replaceAll("\\s","");
        body.put("data", finalString);
        body.put("type", b_type);
    }

    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put("Content-Type", "application/json");

        call = aRequest.setMyProfilePic(headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
