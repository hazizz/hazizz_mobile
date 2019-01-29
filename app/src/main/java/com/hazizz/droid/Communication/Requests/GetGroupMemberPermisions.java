package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroupMemberPermisions extends Request {
    private String p_groupId;
    GetGroupMemberPermisions(Context c, CustomResponseHandler rh, int p_groupId) {
        super(c, rh);
        Log.e("hey", "created GetGroupMemberPermisions object");
        this.p_groupId = Integer.toString(p_groupId);
    }
    @Override public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getGroupMemberPermissions(p_groupId, headerMap);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPermisionUsers pojo = gson.fromJson(response.body().charStream(), PojoPermisionUsers.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
