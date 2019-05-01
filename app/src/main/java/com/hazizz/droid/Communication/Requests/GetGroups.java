package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoGroup;

import java.lang.reflect.Type;
import java.util.ArrayList;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroups extends Request {
    public GetGroups(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetGroups object");
    }

    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getGroups(headerMap);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Log.e("hey", "response.isSuccessful()");
        Type listType = new TypeToken<ArrayList<PojoGroup>>() {
        }.getType();
        ArrayList<PojoGroup> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
