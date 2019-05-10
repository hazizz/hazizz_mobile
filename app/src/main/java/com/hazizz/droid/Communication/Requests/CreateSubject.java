package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class CreateSubject extends Request {
    String p_groupId, b_subjectName;
    public CreateSubject(Activity act, CustomResponseHandler rh, int p_groupId, String b_subjectName) {
        super(act, rh);
        Log.e("hey", "created CreateSubject object");
        this.p_groupId = Integer.toString(p_groupId);
        body.put("name", b_subjectName);
    }
    public void setupCall() {

        headerMap.put("Content-Type", "application/json");
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.createSubject(p_groupId, headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
