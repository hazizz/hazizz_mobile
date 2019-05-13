package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTask;
import com.hazizz.droid.converter.Converter;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetTasksFromMe extends Request {
    private Context context;

    public GetTasksFromMe(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        context = act;
        Log.e("hey", "created GetTasks object");
    }

    public GetTasksFromMe(Context context, CustomResponseHandler rh) {
        Log.e("hey", "created GetTasks object");
        this.context = context;
        this.cOnResponse = rh;
    }

    public void setupCall() {
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getTasksFromMe(header));
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoTask>>(){}.getType();
        List< PojoTask> castedList = null;
        try {
            String rawResponseBody = response.body().string();
            castedList = Converter.fromJson(rawResponseBody, listType);
            cOnResponse.getRawResponseBody(rawResponseBody);
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "ioexception lololol");
        }
        cOnResponse.onPOJOResponse(castedList);
    }

    /*

    public void makeIndependentCall(){
        call(context, this, call, getResponseHandler(), gson);
    }

    */
}
