package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.Strings;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class EditAT extends Request {
    private String p_whereName;
    private String p_whereId;
    public EditAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, int p_whereId,
                  int b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
        super(act, rh);
        Log.e("hey", "created EditAT object");
        this.p_whereName = p_whereName.toString();
        this.p_whereId = Integer.toString(p_whereId);
        body.put("taskType", b_taskType);
        body.put("taskTitle", b_taskTitle);
        body.put("description", b_description);
        body.put("dueDate", b_dueDate);
    }
    public EditAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, int p_whereId,
           String b_announcementTitle, String b_description){
        super(act, rh);
        Log.e("hey", "created EditAT object");
        this.p_whereName = p_whereName.toString();
        this.p_whereId = Integer.toString(p_whereId);
        body.put("announcementTitle", b_announcementTitle);
        body.put("description", b_description);
    }

    public void setupCall() {
        putHeaderAuthToken();
        putHeaderContentType();
        buildCall(RequestSender.getHazizzRequestTypes().editAT(p_whereName, p_whereId, header, body));
    }
    @Override public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
