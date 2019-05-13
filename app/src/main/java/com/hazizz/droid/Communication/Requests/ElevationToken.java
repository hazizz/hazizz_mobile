package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.AuthRequest;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoToken;
import com.hazizz.droid.converter.Converter;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ElevationToken extends AuthRequest {
    public ElevationToken(Activity act, CustomResponseHandler rh, String b_hashedOldPassword) {
        super(act, rh);
        Log.e("hey", "created ElevationToken object");
        body.put("password", b_hashedOldPassword);
    }
    public void setupCall() {
        putHeaderAuthToken();
        putHeaderContentType();
        buildCall(RequestSender.getAuthRequestTypes().elevationToken(header, body));
    }
    /*
    @Override
    public void makeCall() {
        callSpec(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgainSpec(act,  thisRequest, call, cOnResponse, gson);
    }
    */
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoToken pojoToken = Converter.fromJson(response.body().charStream(), PojoToken.class);
        cOnResponse.onPOJOResponse(pojoToken);
    }
}
