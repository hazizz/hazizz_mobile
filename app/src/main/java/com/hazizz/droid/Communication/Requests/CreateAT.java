package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class CreateAT extends Request {
    private String p_whereName, p_byName;
    private int p_byId;
    public CreateAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, String p_byName, int p_byId,
             int b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
        super(act, rh);
        Log.e("hey", "created CreateAT object");

        this.p_whereName = p_whereName.toString();
        this.p_byName = p_byName;
        this.p_byId = p_byId;

        body.put("taskType", b_taskType);
        body.put("taskTitle", b_taskTitle);
        body.put("description", b_description);
        body.put("dueDate", b_dueDate);

    }

    public CreateAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, Strings.Path p_byName, int p_byId,
                    String b_announcementTitle, String b_description) {
        super(act, rh);
        Log.e("hey", "created CreateAT object");
        this.p_whereName = p_whereName.toString();
        this.p_byName = p_byName.toString();
        this.p_byId = p_byId;

        body.put("announcementTitle", b_announcementTitle);
        body.put("description", b_description);

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
        call = aRequest.createAT(p_whereName.toString(), p_byName.toString(),
                Integer.toString(p_byId), headerMap, body);

    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
