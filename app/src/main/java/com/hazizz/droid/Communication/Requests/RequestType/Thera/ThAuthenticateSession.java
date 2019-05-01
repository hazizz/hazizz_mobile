package com.hazizz.droid.Communication.requests.RequestType.Thera;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.ThRequest;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThAuthenticateSession extends ThRequest {
    String p_session;
    public ThAuthenticateSession(Activity act, CustomResponseHandler rh, long p_session, String b_password) {
        super(act, rh);
        Log.e("hey", "created ThAuthenticateSession object");

        this.p_session = Long.toString(p_session);

        body.put("password", b_password);

    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put(HEADER_CONTENTTYPE, HEADER_VALUE_CONTENTTYPE);

        call = aRequest.th_authenticateSession(p_session ,headerMap, body);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoSession pojo = gson.fromJson(response.body().charStream(), PojoSession.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
