package com.hazizz.droid.Communication.requests.myTask;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class DeleteMyTask extends Request{
    String p_taskId;
    public DeleteMyTask(Activity act, CustomResponseHandler rh, int p_taskId) {
        super(act, rh);
        this.p_taskId = Integer.toString(p_taskId);
        Log.e("hey", "created DeleteMyTask object");

    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.deleteMyTask(p_taskId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
