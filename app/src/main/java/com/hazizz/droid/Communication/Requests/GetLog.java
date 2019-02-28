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
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getLog(p_logSize, headerMap);
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
