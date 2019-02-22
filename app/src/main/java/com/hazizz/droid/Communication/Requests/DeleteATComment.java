package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class DeleteATComment extends Request {
    String whereName, whereId, commentId;
    public DeleteATComment(Activity act, CustomResponseHandler rh, Strings.Path whereName, int whereId, long commentId) {
        super(act, rh);
        Log.e("hey", "created DeleteATComment object");
        this.whereName = whereName.toString();
        this.whereId = Integer.toString(whereId);
        this.commentId = Long.toString(commentId);
    }


    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        call = aRequest.deleteATComment(whereName, whereId, commentId,headerMap);
    }
    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        cOnResponse.onSuccessfulResponse();
    }
}
