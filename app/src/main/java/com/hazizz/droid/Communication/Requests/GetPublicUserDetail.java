package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoPublicUserData;
import com.hazizz.droid.converter.Converter;

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
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getPublicUserDetail(userId, header));
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPublicUserData castedObject = Converter.fromJson(response.body().charStream(), PojoPublicUserData.class);
        cOnResponse.onPOJOResponse(castedObject);
    }
}
