package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoMembersProfilePic;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;

public class GetGroupMembersProfilePicSync extends Request {
    String groupId;
    GetGroupMembersProfilePicSync(Activity act, CustomResponseHandler rh, int groupId) {
        super(act, rh);
        Log.e("hey", "created GetGroupMembersProfilePicSync object");
        this.groupId = Integer.toString(groupId);
    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getGroupMembersProfilePic(groupId ,headerMap);
    }
    @Override
    public void makeCall() {
        try {
            Response<ResponseBody> response = call.execute();
            Type listType = new TypeToken<HashMap<Integer, PojoMembersProfilePic>>(){}.getType();
            HashMap<Integer, PojoMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);

            cOnResponse.onPOJOResponse(castedMap);
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "exception");
        }
    }

    public HashMap<Integer, PojoMembersProfilePic> getGroupMembersProfilePic(){
        Response<ResponseBody> response = null;
        try {
            response = call.execute();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Type listType = new TypeToken<HashMap<Integer, PojoMembersProfilePic>>(){}.getType();
        HashMap<Integer, PojoMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
        return castedMap;
    }


    public void call(Context act, Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){

    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) { }
}
