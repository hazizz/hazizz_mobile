package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.enums.EnumAT;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class DeleteATComment extends Request {
    String whereName, whereId, commentId;
    public DeleteATComment(Activity act, CustomResponseHandler rh, EnumAT whereName, int whereId, long commentId) {
        super(act, rh);
        Log.e("hey", "created DeleteATComment object");
        this.whereName = whereName.toString();
        this.whereId = Integer.toString(whereId);
        this.commentId = Long.toString(commentId);
    }


    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.deleteATComment(whereName, whereId, commentId,headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
