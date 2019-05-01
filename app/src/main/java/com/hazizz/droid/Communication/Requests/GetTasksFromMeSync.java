package com.hazizz.droid.Communication.requests;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoTask;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;

public class GetTasksFromMeSync extends Request {
    private Context context;
    public GetTasksFromMeSync(Context context, CustomResponseHandler rh) {
        super(null, rh);
        this.context = context;
        Log.e("hey", "created GetTasksFromMeSync object");
    }
    public GetTasksFromMeSync(Context context) {
        this.context = context;
        Log.e("hey", "created GetTasksFromMeSync object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken(context));
        call = aRequest.getTasksFromMe(headerMap);
    }
    @Override
    public void makeCall() {
        try {
            Response<ResponseBody> response = call.execute();
            try {
                Type listType = new TypeToken<ArrayList<PojoTask>>() {}.getType();
                List< PojoTask> castedList = gson.fromJson(response.body().charStream(), listType);
                cOnResponse.onPOJOResponse(castedList);
            }catch (Exception e){
                PojoError error = gson.fromJson(response.errorBody().charStream(), PojoError.class);
                cOnResponse.onErrorResponse(error);
            }
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "exception");
        }
    }

    public void call(Context act, Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        try {
            Response<ResponseBody> response = call.execute();
            Type listType = new TypeToken<ArrayList< PojoTask>>() {}.getType();
            List< PojoTask> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "exception");
        }
    }

    public List< PojoTask> syncCall(){
        try {
            Response<ResponseBody> response = call.execute();
            Type listType = new TypeToken<ArrayList< PojoTask>>(){}.getType();
            List< PojoTask> castedList = gson.fromJson(response.body().charStream(), listType);
            return castedList;
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "exception");
            return null;
        }
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) { }



}
