package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoAuth;
import com.hazizz.droid.converter.Converter;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class LoginWithRefresh extends Request {
    String b_username, refreshToken;
    public LoginWithRefresh(Activity act, CustomResponseHandler rh, String b_username, String refreshToken) {
        super(act, rh);
        Log.e("hey", "created Login object");
        this.b_username = b_username;
        this.refreshToken = refreshToken;
    }
    public void setupCall() {
        body.put("username", b_username);
        body.put("refreshToken", refreshToken);

        putHeaderAuthToken();
        putHeaderContentType();
        buildCall(RequestSender.getAuthRequestTypes().login(header, body));
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoAuth PojoAuth = Converter.fromJson(response.body().charStream(), PojoAuth.class);
        cOnResponse.onPOJOResponse(PojoAuth);
    }
}