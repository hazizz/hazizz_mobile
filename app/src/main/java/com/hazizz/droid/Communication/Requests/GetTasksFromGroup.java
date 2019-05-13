package com.hazizz.droid.communication.requests;

import android.app.Activity;
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

public class GetTasksFromGroup extends Request {
    private String p_groupId;
    public GetTasksFromGroup(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created GetTasksFromGroup object");
        this.p_groupId = Integer.toString(p_groupId);
    }
    public void setupCall() {

        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getTasksFromGroup(p_groupId, header));

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
}
