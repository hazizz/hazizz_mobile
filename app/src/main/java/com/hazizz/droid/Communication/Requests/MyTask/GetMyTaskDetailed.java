package com.hazizz.droid.Communication.Requests.MyTask;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetMyTaskDetailed extends Request{
    public GetMyTaskDetailed(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetAT object");
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.getMyTaskDetailed(headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        POJOgetTaskDetailed pojo = gson.fromJson(response.body().charStream(), POJOgetTaskDetailed.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
