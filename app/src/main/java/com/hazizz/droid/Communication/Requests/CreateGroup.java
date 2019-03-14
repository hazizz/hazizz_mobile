package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.Request;
import com.hazizz.droid.Communication.Strings;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class CreateGroup extends Request {
    public CreateGroup(Activity act, CustomResponseHandler rh, String b_groupName, Strings.GroupType b_groupType) {
        super(act, rh);
        Log.e("hey", "created CreateGroup object");
        body.put("groupName", b_groupName);
        body.put("type", b_groupType);
    }
    public CreateGroup(Activity act, CustomResponseHandler rh, String b_groupName, String b_password) {
        super(act, rh);
        Log.e("hey", "created CreateGroup object");
        body.put("groupName", b_groupName);
        body.put("password", b_password);
        body.put("type", Strings.GroupType.PASSWORD.getValue());
    }
    public void setupCall() {

        headerMap.put("Content-Type", "application/json");
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.createGroup(headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
        cOnResponse.getHeaders(response.headers());
    }
}
