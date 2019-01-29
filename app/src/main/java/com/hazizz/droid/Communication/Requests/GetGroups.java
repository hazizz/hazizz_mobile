package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.SharedPrefs;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroups extends Request {
    GetGroups(Context c, CustomResponseHandler rh) {
        super(c, rh);
        Log.e("hey", "created GetGroups object");
    }
    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getGroups(headerMap);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Log.e("hey", "response.isSuccessful()");
        Type listType = new TypeToken<ArrayList<POJOgroup>>() {
        }.getType();
        ArrayList<POJOgroup> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
