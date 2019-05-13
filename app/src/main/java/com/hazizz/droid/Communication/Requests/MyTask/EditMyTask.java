package com.hazizz.droid.communication.requests.myTask;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class EditMyTask extends Request {
    String p_taskId;
    public EditMyTask(Activity act, CustomResponseHandler rh, int p_taskId,
                      int b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
        super(act, rh);
        Log.e("hey", "created EditMyTask object");
        this.p_taskId = Integer.toString(p_taskId);
        body.put("taskType", b_taskType);
        body.put("taskTitle", b_taskTitle);
        body.put("description", b_description);
        body.put("dueDate", b_dueDate);
    }

    public void setupCall() {
        putHeaderAuthToken();
        putHeaderContentType();
        buildCall(RequestSender.getHazizzRequestTypes().updateMyTask(p_taskId, body, header));
    }
    @Override public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
