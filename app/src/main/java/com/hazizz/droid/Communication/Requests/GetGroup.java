package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.converter.Converter;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroup extends Request {
    private String p_groupId;
    public GetGroup(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created GetGroup object");
        this.p_groupId = Integer.toString(p_groupId);
    }


    public void setupCall() {

        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getGroup(p_groupId, header));
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {

        PojoGroup PojoGroup = Converter.fromJson(response.body().charStream(), PojoGroup.class);
        cOnResponse.onPOJOResponse(PojoGroup);
    }
}
