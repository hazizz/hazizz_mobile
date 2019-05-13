package com.hazizz.droid.communication.requests.myTask;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTaskDetailed;
import com.hazizz.droid.converter.Converter;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetMyTaskDetailed extends Request{
    public GetMyTaskDetailed(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetAT object");
    }
    public void setupCall() {

        putHeaderAuthToken();

        buildCall(RequestSender.getHazizzRequestTypes().getMyTaskDetailed(header));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
         PojoTaskDetailed pojo = Converter.fromJson(response.body().charStream(),  PojoTaskDetailed.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
