package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.SharedPrefs;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;

public class GetGroupMembersProfilePicSync extends Request {
    String groupId;
    GetGroupMembersProfilePicSync(Context c, CustomResponseHandler rh, int groupId) {
        super(c, rh);
        Log.e("hey", "created GetGroupMembersProfilePicSync object");
        this.groupId = Integer.toString(groupId);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getGroupMembersProfilePic(groupId ,headerMap);
    }
    @Override
    public void makeCall() {
        try {
            Response<ResponseBody> response = call.execute();
            Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
            HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);

            cOnResponse.onPOJOResponse(castedMap);
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "exception");
        }
    }

    public HashMap<Integer, POJOMembersProfilePic> getGroupMembersProfilePic(){
        Response<ResponseBody> response = null;
        try {
            response = call.execute();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
        HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
        return castedMap;
    }

    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void call(Context act, Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){

    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) { }
}
