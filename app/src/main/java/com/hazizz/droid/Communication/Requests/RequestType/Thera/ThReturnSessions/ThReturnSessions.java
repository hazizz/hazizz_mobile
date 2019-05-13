package com.hazizz.droid.communication.requests.RequestType.Thera.ThReturnSessions;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.ThRequest;
import com.hazizz.droid.communication.requests.RequestType.Thera.PojoSession;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.converter.Converter;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThReturnSessions extends ThRequest {
    public ThReturnSessions(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created ThReturnSessions object");
    }
    public void setupCall() {

        putHeaderAuthToken();
        buildCall(RequestSender.getTheraRequestTypes().th_returnSessions(header));

    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoSession>>(){}.getType();
        List<PojoSession> castedList = Converter.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}
