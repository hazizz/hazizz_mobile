package com.hazizz.droid.Communication.Requests.MyTask;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class CreateMyTask extends Request{
    public CreateMyTask(Activity act, CustomResponseHandler rh,
                    int b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
        super(act, rh);
        Log.e("hey", "created CreateMyTask object");

        body.put("taskType", b_taskType);
        body.put("taskTitle", b_taskTitle);
        body.put("description", b_description);
        body.put("dueDate", b_dueDate);
    }
    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Content-Type", "application/json");
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.createMyTask(body,headerMap);

    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
