package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.Request;

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
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.returnInviteLink(p_groupId, headerMap);
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
