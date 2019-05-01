package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoTask;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetTasksFromGroup extends Request {
    String p_groupId;
    public GetTasksFromGroup(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created GetTasksFromGroup object");
        this.p_groupId = Integer.toString(p_groupId);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getTasksFromGroup(p_groupId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoTask>>(){}.getType();

        List< PojoTask> castedList = null;
        try {
            String rawResponseBody = response.body().string();
            castedList = gson.fromJson(rawResponseBody, listType);
            cOnResponse.getRawResponseBody(rawResponseBody);
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("hey", "ioexception lololol");
        }

        cOnResponse.onPOJOResponse(castedList);
    }
}
