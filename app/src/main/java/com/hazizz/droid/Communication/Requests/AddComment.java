package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class AddComment extends Request {
    String p_whereName, p_whereId, p_byName, p_byId;
    AddComment(Context c, CustomResponseHandler rh, String content) {
        super(c, rh);
        Log.e("hey", "created AddComment object");
        body.put("content", content);
    }

    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        headerMap.put("Content-Type", "application/json");

        call = aRequest.addComment(p_whereName, p_byName, p_byId, p_whereId, headerMap, body);
        Log.e("hey", "setup call on AddComment");
    }

    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
