package com.hazizz.droid.communication.requests.RequestType.Thera;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.ThRequest;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.converter.Converter;

import java.lang.reflect.Type;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThSchools extends ThRequest {
    public ThSchools(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created ThSchools object");
    }
    public void setupCall() {

        putHeaderAuthToken();

        buildCall(RequestSender.getTheraRequestTypes().th_getSchools(header));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<HashMap<String, String>>(){}.getType();
        HashMap<String, String> castedMap = Converter.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedMap);
    }
}
