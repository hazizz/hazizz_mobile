package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetATBy extends Request {
    private String p_whereName, p_byName;
    private String p_byId, p_whereId;
    GetATBy(Context c, CustomResponseHandler rh, Strings.Path p_whereName, Strings.Path p_byName, int p_byId, int p_whereId) {
        super(c, rh);
        Log.e("hey", "created GetATBy object");
        this.p_whereName = p_whereName.toString();
        this.p_byName = p_byName.toString();
        this.p_byId = Integer.toString(p_byId);
        this.p_whereId = Integer.toString(p_whereId);
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        call = aRequest.getATBy(p_whereName, p_byName, p_byId, p_whereId, headerMap);
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
        POJOgetTaskDetailed pojo = gson.fromJson(response.body().charStream(), POJOgetTaskDetailed.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
