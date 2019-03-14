package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class AddComment extends Request {
    String p_whereName, p_whereId;
    public AddComment(Activity act, CustomResponseHandler rh, String p_whereName, int p_whereId,
                      String b_content) {
        super(act, rh);
        this.p_whereId = Integer.toString(p_whereId);
        this.p_whereName = p_whereName;
        body.put("content", b_content);
        Log.e("hey", "created AddComment object");
    }

    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put("Content-Type", "application/json");

        call = aRequest.addComment(p_whereName, p_whereId, headerMap, body);
        Log.e("hey", "setup call on AddComment");
    }





    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
