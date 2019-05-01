package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class inviteUserToGroup extends Request {
    String groupId;
    public inviteUserToGroup(Activity act, CustomResponseHandler rh, int groupId) {
        super(act, rh);
        this.groupId = Integer.toString(groupId);
        Log.e("hey", "created inviteUserToGroup object");
    }
    public void setupCall() {

        headerMap.put("Content-Type", "application/json");
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
       // call = aRequest.inviteUserToGroup(vars.get(Strings.Path.GROUPID).toString(), headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
