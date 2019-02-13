package com.hazizz.droid.Communication.Requests;

import android.app.Activity;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.SharedPrefs;

import java.io.IOException;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetLog extends Request{
    String p_logSize;
    public GetLog(Activity act, CustomResponseHandler cOnResponse, int p_logSize) {
        super(act, cOnResponse);
        this.p_logSize = Integer.toString(p_logSize);
    }

    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getLog(p_logSize, headerMap);

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
        try {
            cOnResponse.onPOJOResponse(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
