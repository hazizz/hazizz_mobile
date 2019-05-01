package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

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

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.deleteAT(whereName, whereId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
