package com.hazizz.droid.Communication.requests.RequestType.Thera.ThReturnSessions;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.ThRequest;
import com.hazizz.droid.Communication.requests.RequestType.Thera.PojoSession;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

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

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.th_returnSessions(headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoSession>>(){}.getType();
        List<PojoSession> castedList = gson.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}
