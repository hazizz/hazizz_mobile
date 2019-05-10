package com.hazizz.droid.communication.requests;

import android.app.Activity;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import java.io.IOException;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetLog extends Request {
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
