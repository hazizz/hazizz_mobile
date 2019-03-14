package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class JoinGroupByPassword extends Request {
    private String p_groupId, p_password;
    public JoinGroupByPassword(Activity act, CustomResponseHandler rh, int p_groupId, String p_password) {
        super(act, rh);
        Log.e("hey", "created JoinGroupByPassword object");
        this.p_groupId = Integer.toString(p_groupId);
        this.p_password = p_password;
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.joinGroupByPassword(p_groupId, p_password, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
