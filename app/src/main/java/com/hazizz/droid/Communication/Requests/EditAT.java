package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class EditAT extends Request {
    private String p_whereName;
    private int p_whereId;
    public EditAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, int p_whereId,
                  int b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
        super(act, rh);
        Log.e("hey", "created EditAT object");
        this.p_whereName = p_whereName.toString();
        this.p_whereId = p_whereId;
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
        this.p_whereId = p_whereId;
        body.put("announcementTitle", b_announcementTitle);
        body.put("description", b_description);
    }
    @Override public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<>();
        headerMap.put("Content-Type", "application/json");
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.editAT(p_whereName, Integer.toString(p_whereId), headerMap, body);
    }
    @Override public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
