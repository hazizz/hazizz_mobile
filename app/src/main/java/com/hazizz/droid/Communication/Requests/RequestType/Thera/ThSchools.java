package com.hazizz.droid.Communication.Requests.RequestType.Thera;

import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.SharedPrefs;

import java.lang.reflect.Type;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThSchools extends Request {
    ThSchools() {
        Log.e("hey", "created ThSchools object");
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        call = tRequest.getSchools(headerMap);
    }
    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<HashMap<String, String>>(){}.getType();
        HashMap<String, String> castedMap = gson.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedMap);
    }
}
