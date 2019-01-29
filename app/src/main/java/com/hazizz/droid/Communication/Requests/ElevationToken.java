package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.PojoToken;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ElevationToken extends Request {
    ElevationToken(Context c, CustomResponseHandler rh, String b_hashedOldPassword) {
        super(c, rh);
        Log.e("hey", "created ElevationToken object");
        body.put("password", b_hashedOldPassword);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        headerMap.put("Content-Type", "application/json");

        call = aRequest.elevationToken(headerMap, body);
    }
    @Override
    public void makeCall() {
        callSpec(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgainSpec(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoToken pojoToken = gson.fromJson(response.body().charStream(), PojoToken.class);
        cOnResponse.onPOJOResponse(pojoToken);
    }
}
