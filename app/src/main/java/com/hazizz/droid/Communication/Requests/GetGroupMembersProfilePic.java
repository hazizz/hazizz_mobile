package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoMembersProfilePic;

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
        Type listType = new TypeToken<HashMap<Long, PojoMembersProfilePic>>(){}.getType();
        HashMap<Long, PojoMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedMap);
    }
}
