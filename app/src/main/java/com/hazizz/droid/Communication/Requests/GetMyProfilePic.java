package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetMyProfilePic extends Request {
    private boolean full = false;
    public GetMyProfilePic(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetMyProfilePic object");
    }

    public GetMyProfilePic full(){
        full = true;
        return this;
    }

    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        if(full){
            call = aRequest.getMyProfilePic("full", headerMap);
        }else{
            call = aRequest.getMyProfilePic("",headerMap);
        }

        Log.e("hey", "setup call on getMyProfilePic");
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoPicSmall pojoPicSmall = gson.fromJson(response.body().charStream(), PojoPicSmall.class);
        cOnResponse.onPOJOResponse(pojoPicSmall);
    }
}
