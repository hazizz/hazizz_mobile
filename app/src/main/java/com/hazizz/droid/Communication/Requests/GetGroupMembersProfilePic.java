package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import java.lang.reflect.Type;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroupMembersProfilePic extends Request {
    String groupId;
    public GetGroupMembersProfilePic(Activity act, CustomResponseHandler rh, long groupId) {
        super(act, rh);
        Log.e("hey", "created GetAnnouncements object");
        this.groupId = Long.toString(groupId);
    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getGroupMembersProfilePic(groupId ,headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<HashMap<Long, POJOMembersProfilePic>>(){}.getType();
        HashMap<Long, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedMap);
    }
}
