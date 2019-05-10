package com.hazizz.droid.communication.requests.myTask;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTaskDetailed;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetMyTaskDetailed extends Request{
    public GetMyTaskDetailed(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetAT object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.getMyTaskDetailed(headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
         PojoTaskDetailed pojo = gson.fromJson(response.body().charStream(),  PojoTaskDetailed.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
