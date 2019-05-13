package com.hazizz.droid.communication.requests.RequestType;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.AuthRequest;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoAuth;
import com.hazizz.droid.converter.Converter;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Login extends AuthRequest {
    String b_username, b_password;
    public Login(Activity act, CustomResponseHandler rh, String b_username, String b_password) {
        super(act, rh);
        Log.e("hey", "created Login object");
        this.b_username = b_username;
        this.b_password = b_password;
    }
    public void setupCall() {
        putHeaderContentType();
        body.put("username", b_username);
        body.put("password", b_password);
        buildCall(RequestSender.getAuthRequestTypes().login(header, body));

    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoAuth PojoAuth = Converter.fromJson(response.body().charStream(), PojoAuth.class);
        cOnResponse.onPOJOResponse(PojoAuth);
    }
}