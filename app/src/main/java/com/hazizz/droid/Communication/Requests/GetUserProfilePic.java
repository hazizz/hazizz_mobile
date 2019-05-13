package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoPicSmall;
import com.hazizz.droid.converter.Converter;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetUserProfilePic extends Request {
    private String p_userId;
    private boolean full = false;
    public GetUserProfilePic(Activity act, CustomResponseHandler rh, long p_userId) {
        super(act, rh);
        Log.e("hey", "created LeaveGroup object");
        this.p_userId = Long.toString(p_userId);
    }

    public GetUserProfilePic full(){
        full = true;
        return this;
    }

    public void setupCall() {
        putHeaderAuthToken();

        if(full){
            buildCall(RequestSender.getHazizzRequestTypes().getUserProfilePic(p_userId,"full", header));
        }else{
            buildCall(RequestSender.getHazizzRequestTypes().getUserProfilePic(p_userId,"", header));

        }
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPicSmall pojoPicSmall = Converter.fromJson(response.body().charStream(), PojoPicSmall.class);
        cOnResponse.onPOJOResponse(pojoPicSmall);
    }
}
