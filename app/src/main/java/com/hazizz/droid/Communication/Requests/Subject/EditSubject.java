package com.hazizz.droid.Communication.Requests.Subject;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class EditSubject extends Request {
    String p_groupId, p_subjectId;
    public EditSubject(Activity act, CustomResponseHandler rh, long p_groupId, long p_subjectId,
                       String b_subjectName) {
        super(act, rh);
        Log.e("hey", "created DeleteATComment object");
        this.p_groupId = Long.toString(p_groupId);
        this.p_subjectId = Long.toString(p_subjectId);
        body.put("name", b_subjectName);
    }


    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.editSubject(p_groupId, p_subjectId, headerMap, body);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}

