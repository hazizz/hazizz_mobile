package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoUser;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoTask;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetUsers extends Request {
    GetUsers(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created TaskEditor object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getUsers(headerMap); //Integer.toString(groupID)
    }
    @Override
    public void makeCall() {
        call(act, thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoUser>>() {
        }.getType();
        List<PojoTask> castedList = gson.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}
