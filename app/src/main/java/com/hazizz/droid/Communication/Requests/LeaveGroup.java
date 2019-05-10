package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class LeaveGroup extends Request {
    private String p_groupId;
    public LeaveGroup(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created LeaveGroup object");
        this.p_groupId = Integer.toString(p_groupId);
    }
    public void setupCall() {

        putHeaderAuthToken();
        putHeaderContentType();
        call = aRequest.leaveGroup(p_groupId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
