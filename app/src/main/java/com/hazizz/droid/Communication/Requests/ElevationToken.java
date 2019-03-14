package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.PojoToken;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ElevationToken extends Request {
    public ElevationToken(Activity act, CustomResponseHandler rh, String b_hashedOldPassword) {
        super(act, rh);
        Log.e("hey", "created ElevationToken object");
        body.put("password", b_hashedOldPassword);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
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
