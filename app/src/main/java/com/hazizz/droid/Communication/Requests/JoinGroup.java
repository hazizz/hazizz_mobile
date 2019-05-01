package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class JoinGroup extends Request {
    private String groupId;
    public JoinGroup(Activity act, CustomResponseHandler rh, int groupId) {
        super(act, rh);
        Log.e("hey", "created JoinGroup object");
        this.groupId = Integer.toString(groupId);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.joinGroup(groupId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
