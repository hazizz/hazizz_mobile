package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetTasksFromMe extends Request {
    public GetTasksFromMe(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetTasks object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getTasksFromMe(headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
        List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
