package com.hazizz.droid.Communication.Requests.Subject;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class DeleteSubject extends Request {
    String p_groupId, p_subjectId;
    public DeleteSubject(Activity act, CustomResponseHandler rh, long p_groupId, long p_subjectId) {
        super(act, rh);
        Log.e("hey", "created DeleteATComment object");
        this.p_groupId = Long.toString(p_groupId);
        this.p_subjectId = Long.toString(p_subjectId);
    }


    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.deleteSubject(p_groupId, p_subjectId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
