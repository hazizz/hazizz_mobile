package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import java.io.IOException;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ReturnInvitationLink extends Request {
    private String p_groupId;
    private boolean full = false;
    public ReturnInvitationLink(Activity act, CustomResponseHandler rh, long p_groupId) {
        super(act, rh);
        Log.e("hey", "created ReturnInvitationLink object");
        this.p_groupId = Long.toString(p_groupId);
    }


    public void setupCall() {
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().returnInviteLink(p_groupId, header));
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        try {
            String link = response.body().string();
            cOnResponse.onPOJOResponse(link);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
