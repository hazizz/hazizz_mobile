package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoType;

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

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getTaskTypes(headerMap); // vars.get(id").toString()
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoType>>() {}.getType();
        ArrayList<PojoType> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
