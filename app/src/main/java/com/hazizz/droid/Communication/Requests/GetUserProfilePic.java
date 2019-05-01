package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoPicSmall;

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

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());


        if(full){
            call = aRequest.getUserProfilePic(p_userId,"full", headerMap);
        }else{
            call = aRequest.getUserProfilePic(p_userId,"",headerMap);
        }
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPicSmall pojoPicSmall = gson.fromJson(response.body().charStream(), PojoPicSmall.class);
        cOnResponse.onPOJOResponse(pojoPicSmall);
    }
}
