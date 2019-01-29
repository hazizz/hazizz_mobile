package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class EditAT extends Request {
    private Strings.Path p_whereName, p_byName;
    private int p_byId, p_whereId;
    EditAT(Context c, CustomResponseHandler rh, Strings.Path p_whereName, Strings.Path p_byName, int p_byId, int p_whereId,
           String b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
        super(c, rh);
        Log.e("hey", "created EditAT object");
        this.p_whereName = p_whereName;
        this.p_byName = p_byName;
        this.p_byId = p_byId;
        this.p_whereId = p_whereId;

        body.put("taskType", b_taskType);
        body.put("taskTitle", b_taskTitle);
        body.put("description", b_description);
        body.put("dueDate", b_dueDate);

    }
    EditAT(Context c, CustomResponseHandler rh, Strings.Path p_whereName, Strings.Path p_byName, int p_byId, int p_whereId,
           String b_announcementTitle, String b_description){
        super(c, rh);
        Log.e("hey", "created EditAT object");
        this.p_whereName = p_whereName;
        this.p_byName = p_byName;
        this.p_byId = p_byId;
        this.p_whereId = p_whereId;

        body.put("announcementTitle", b_announcementTitle);
        body.put("description", b_description);
    }

    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }@Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Content-Type", "application/json");
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
        call = aRequest.editAT(p_whereName.toString(), p_byName.toString(),
                Integer.toString(p_byId), Integer.toString(p_whereId), headerMap, body);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
