package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class DeleteAT extends Request {
    String whereName, whereId, byName, byId;
    DeleteAT(Context c, CustomResponseHandler rh, Strings.Rank whereName, Strings.Rank whereId, Strings.Rank byName, Strings.Rank byId) {
        super(c, rh);
        Log.e("hey", "created DeleteAT object");
        this.whereName = whereName.toString();
        this.whereId = whereId.toString();
        this.byName = byName.toString();
        this.byId = byId.toString();

    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        call = aRequest.DeleteAT(whereName, byName, byId, whereId, headerMap);
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
