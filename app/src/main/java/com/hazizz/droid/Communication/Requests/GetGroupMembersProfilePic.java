package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoMembersProfilePic;
import com.hazizz.droid.converter.Converter;

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
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getGroupMembersProfilePic(groupId, header));
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<HashMap<Long, PojoMembersProfilePic>>(){}.getType();
        HashMap<Long, PojoMembersProfilePic> castedMap = Converter.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedMap);
    }
}
