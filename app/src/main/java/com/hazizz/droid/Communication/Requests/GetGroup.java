package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroup extends Request {
    private int p_groupId;
    GetGroup(Context c, CustomResponseHandler rh, int p_groupId) {
        super(c, rh);
        Log.e("hey", "created GetGroup object");
        this.p_groupId = p_groupId;
    }
    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getGroup(Integer.toString(p_groupId), headerMap);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        POJOgroup pojoGroup = gson.fromJson(response.body().charStream(), POJOgroup.class);
        cOnResponse.onPOJOResponse(pojoGroup);
    }
}
