package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.SharedPrefs;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetTasksFromMe extends Request {
    GetTasksFromMe(Context c, CustomResponseHandler rh) {
        super(c, rh);
        Log.e("hey", "created GetTasks object");
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getTasksFromMe(headerMap);
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
        Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
        List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
