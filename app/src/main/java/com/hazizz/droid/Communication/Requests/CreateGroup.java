package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class CreateGroup extends Request {
    public CreateGroup(Activity act, CustomResponseHandler rh, String b_groupName, String b_groupType) {
        super(act, rh);
        Log.e("hey", "created CreateGroup object");
        body.put("groupName", b_groupName);
        body.put("type", b_groupType);
    }
    public CreateGroup(Activity act, CustomResponseHandler rh, String b_groupName, String b_groupType, String b_password) {
        super(act, rh);
        Log.e("hey", "created CreateGroup object");
        body.put("groupName", b_groupName);
        body.put("password", b_password);
        body.put("type", b_groupType);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Content-Type", "application/json");
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        call = aRequest.createGroup(headerMap, body);
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
        cOnResponse.onSuccessfulResponse();
        cOnResponse.getHeaders(response.headers());
    }
}
