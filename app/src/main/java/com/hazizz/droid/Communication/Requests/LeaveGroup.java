package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class LeaveGroup extends Request {
    private String p_groupId;
    public LeaveGroup(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created LeaveGroup object");
        this.p_groupId = Integer.toString(p_groupId);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put("Content-Type", "application/json");
        call = aRequest.getGroupMembers(p_groupId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
