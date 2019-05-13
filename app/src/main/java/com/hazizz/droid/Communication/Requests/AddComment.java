package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

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

        putHeaderAuthToken();
        putHeaderContentType();
        buildCall(RequestSender.getHazizzRequestTypes().addComment(p_whereName, p_whereId, header, body));

        Log.e("hey", "setup call on AddComment");
    }





    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
