package com.hazizz.droid.communication.requests.RequestType.Thera;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.ThRequest;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.converter.Converter;

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
        putHeaderAuthToken();
        header.put(HEADER_CONTENTTYPE, HEADER_VALUE_CONTENTTYPE);

        buildCall(RequestSender.getTheraRequestTypes().th_authenticateSession(p_session ,header, body));

    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoSession pojo = Converter.fromJson(response.body().charStream(), PojoSession.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
