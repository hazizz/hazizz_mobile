package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.SharedPrefs;

import java.lang.reflect.Type;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroupMembersProfilePic extends Request {
    String groupId;
    public GetGroupMembersProfilePic(Activity act, CustomResponseHandler rh, int groupId) {
        super(act, rh);
        Log.e("hey", "created GetAnnouncements object");
        this.groupId = Integer.toString(groupId);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getGroupMembersProfilePic(groupId ,headerMap);
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
        Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
        HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedMap);
        Log.e("hey", "size of response map: " + castedMap.size());
    }
}
