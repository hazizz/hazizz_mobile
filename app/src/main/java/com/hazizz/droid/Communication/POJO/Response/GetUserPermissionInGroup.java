package com.hazizz.droid.Communication.POJO.Response;


import android.app.Activity;
import android.util.Log;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.SharedPrefs;

import java.io.IOException;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetUserPermissionInGroup extends Request {
    private String p_groupId, p_userId;
    public GetUserPermissionInGroup(Activity act, CustomResponseHandler rh, int p_groupId, int p_userId) {
        super(act, rh);
        Log.e("hey", "created GetUserPermissionInGroup object");
        this.p_groupId = Integer.toString(p_groupId);
        this.p_userId =  Integer.toString(p_userId);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        call = aRequest.getUserPermissionInGroup(p_groupId, p_userId, headerMap);
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
       // POJOgetTaskDetailed pojo = gson.fromJson(response.body().charStream(), POJOgetTaskDetailed.class);
        try {
            cOnResponse.onPOJOResponse(response.body().string().replaceAll("\"", ""));
        } catch (IOException e) {
            e.printStackTrace();
        }


    }
}
