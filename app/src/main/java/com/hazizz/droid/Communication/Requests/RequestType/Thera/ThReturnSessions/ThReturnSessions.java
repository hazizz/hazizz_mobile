package com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnSessions;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThCreateSession.PojoSession;

import java.lang.reflect.Type;
import java.util.ArrayList;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThReturnSessions extends Request {
    public ThReturnSessions(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created ThReturnSessions object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = tRequest.th_returnSessions(headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<PojoSession>(){}.getType();
        ArrayList<PojoSession> castedList = gson.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}
