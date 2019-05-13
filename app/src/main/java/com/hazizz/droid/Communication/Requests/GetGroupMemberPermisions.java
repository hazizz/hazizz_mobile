package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoPermisionUsers;
import com.hazizz.droid.converter.Converter;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroupMemberPermisions extends Request {
    private String p_groupId;
    public GetGroupMemberPermisions(Activity act, CustomResponseHandler rh, long p_groupId) {
        super(act, rh);
        Log.e("hey", "created GetGroupMemberPermisions object");
        this.p_groupId = Long.toString(p_groupId);
    }

    public void setupCall() {
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getGroupMemberPermissions(p_groupId, header));
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPermisionUsers pojo = Converter.fromJson(response.body().charStream(), PojoPermisionUsers.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
