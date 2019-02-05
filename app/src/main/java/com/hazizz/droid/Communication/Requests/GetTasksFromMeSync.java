package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.SharedPrefs;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;

public class GetTasksFromMeSync extends Request {
    private Context c;
    public GetTasksFromMeSync(Context c, CustomResponseHandler rh) {
        super(null, rh);
        this.c = c;
        Log.e("hey", "created GetTasksFromMeSync object");
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(c));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.getTasksFromMe(headerMap);
    }
    @Override
    public void makeCall() {
        try {
            Response<ResponseBody> response = call.execute();
            try {
                Type listType = new TypeToken<ArrayList<POJOgetTask>>() {
                }.getType();
                List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
                cOnResponse.onPOJOResponse(castedList);
            }catch (Exception e){
                POJOerror error = gson.fromJson(response.errorBody().charStream(), POJOerror.class);
                cOnResponse.onErrorResponse(error);
            }
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "exception");
        }
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void call(Context act, Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        try {
            Response<ResponseBody> response = call.execute();
            Type listType = new TypeToken<ArrayList<POJOgetTask>>() {
            }.getType();
            List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "exception");
        }
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) { }
}
