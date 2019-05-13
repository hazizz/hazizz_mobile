package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class DeleteAnnouncement extends Request {
    public DeleteAnnouncement(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created UpdateTask object");
    }


    public void setupCall() {

        putHeaderAuthToken();
     //   call = aRequest.deleteAnnouncement(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.ANNOUNCEMENTID).toString(), header); //Integer.toString(groupID)
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
