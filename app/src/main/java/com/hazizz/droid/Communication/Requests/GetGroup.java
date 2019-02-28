package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroup extends Request {
    private int p_groupId;
    GetGroup(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created GetGroup object");
        this.p_groupId = p_groupId;
    }


    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getGroup(Integer.toString(p_groupId), headerMap);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        POJOgroup pojoGroup = gson.fromJson(response.body().charStream(), POJOgroup.class);
        cOnResponse.onPOJOResponse(pojoGroup);
    }
}
