package com.hazizz.droid.Communication.Requests.RequestType.Thera;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.SharedPrefs;

import java.lang.reflect.Type;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThSchools extends Request {
    public ThSchools(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created ThSchools object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = tRequest.th_getSchools(headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<HashMap<String, String>>(){}.getType();
        HashMap<String, String> castedMap = gson.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedMap);
    }
}
