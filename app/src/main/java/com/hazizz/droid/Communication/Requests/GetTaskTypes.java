package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoType;
import com.hazizz.droid.converter.Converter;

import java.lang.reflect.Type;
import java.util.ArrayList;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetTaskTypes extends Request {
    GetTaskTypes(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetTaskTypes object");
    }

    public void setupCall() {
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getTaskTypes(header));

    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoType>>() {}.getType();
        ArrayList<PojoType> castedList = Converter.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
