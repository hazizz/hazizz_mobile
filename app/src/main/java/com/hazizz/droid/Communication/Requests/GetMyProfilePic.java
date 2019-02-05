package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetMyProfilePic extends Request {
    private boolean full = false;
    public GetMyProfilePic(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetMyProfilePic object");
    }

    public GetMyProfilePic full(){
        full = true;
        return this;
    }

    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        if(full){
            call = aRequest.getMyProfilePic("full", headerMap);
        }else{
            call = aRequest.getMyProfilePic("",headerMap);
        }

        Log.e("hey", "setup call on getMyProfilePic");
    }
    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPicSmall pojoPicSmall = gson.fromJson(response.body().charStream(), PojoPicSmall.class);
        cOnResponse.onPOJOResponse(pojoPicSmall);
    }
}
