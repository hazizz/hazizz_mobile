package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.Strings;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class DeleteAT extends Request {
    String whereName, whereId;
    public DeleteAT(Activity act, CustomResponseHandler rh, Strings.Path whereName, int whereId) {
        super(act, rh);
        Log.e("hey", "created DeleteAT object");
        this.whereName = whereName.toString();
        this.whereId = Integer.toString(whereId);

    }


    public void setupCall() {

        putHeaderAuthToken();

        buildCall(RequestSender.getHazizzRequestTypes().deleteAT(whereName, whereId, header));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
