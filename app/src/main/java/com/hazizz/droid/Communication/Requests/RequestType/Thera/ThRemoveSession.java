package com.hazizz.droid.communication.requests.RequestType.Thera;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.ThRequest;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThRemoveSession extends ThRequest {
    String p_session;
    public ThRemoveSession(Activity act, CustomResponseHandler rh, int p_session) {
        super(act, rh);
        Log.e("hey", "created ThRemoveSession object");

        this.p_session = Integer.toString(p_session);
    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put(HEADER_CONTENTTYPE, HEADER_VALUE_CONTENTTYPE);

        call = aRequest.th_removeSession(p_session, headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}