package com.hazizz.droid.Communication.Requests.RequestType;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOauth;
import com.hazizz.droid.Communication.RequestInterface;
import com.hazizz.droid.Communication.Requests.Request;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class Login extends Request  {
    String b_username, b_password;
    public Login(Context c, CustomResponseHandler rh, String b_username, String b_password) {
        super(c, rh);
        Log.e("hey", "created Login object");
        this.b_username = b_username;
        this.b_password = b_password;
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<>();
        headerMap.put("Content-Type", "application/json");
        HashMap<String, String> b = new HashMap<>();
        b.put("username", b_username);
        b.put("password", b_password);
        call = aRequest.login(headerMap, body);
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
        POJOauth pojoAuth = gson.fromJson(response.body().charStream(), POJOauth.class);
        cOnResponse.onPOJOResponse(pojoAuth);
    }
}