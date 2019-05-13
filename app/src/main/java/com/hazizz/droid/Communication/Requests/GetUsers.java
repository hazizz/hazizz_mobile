package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoUser;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTask;
import com.hazizz.droid.converter.Converter;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetUsers extends Request {
    GetUsers(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created TaskEditor object");
    }
    public void setupCall() {
        putHeaderAuthToken();
        //  call = aRequest.th_returnSchedules(p_sessionId, q_weekNumber, q_year,headerMap);
        buildCall(RequestSender.getHazizzRequestTypes().getUsers(header));

    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoUser>>() {}.getType();
        List<PojoTask> castedList = Converter.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}
