package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.Requests.Parent.Request;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroupMembers extends Request {
    private String p_groupId;
    GetGroupMembers(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created getGroupMembers object");
        this.p_groupId = Integer.toString(p_groupId);
    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getGroupMembers(p_groupId, headerMap);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<POJOuser>>(){}.getType();
        List<POJOuser> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
