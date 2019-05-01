package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoPublicUserData;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetPublicUserDetail extends Request {
    String userId;
    public GetPublicUserDetail(Activity act, CustomResponseHandler rh, int userId) {
        super(act, rh);
        Log.e("hey", "created getPublicUserDetail object");
        this.userId = Integer.toString(userId);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getPublicUserDetail(userId,headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPublicUserData castedObject = gson.fromJson(response.body().charStream(), PojoPublicUserData.class);
        cOnResponse.onPOJOResponse(castedObject);
    }
}
