package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
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
    public GetATBy(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, int p_whereId, String p_byName, int p_byId) {
        super(act, rh);
        Log.e("hey", "created GetATBy object");
        this.p_whereName = p_whereName.toString();
        this.p_byName = p_byName;
        this.p_byId = Integer.toString(p_byId);
        this.p_whereId = Integer.toString(p_whereId);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.getATBy(p_whereName, p_byName, p_byId, p_whereId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        if(p_whereName.equals(Strings.Path.TASKS.toString())) {
            POJOgetTaskDetailed pojo = gson.fromJson(response.body().charStream(), POJOgetTaskDetailed.class);
            cOnResponse.onPOJOResponse(pojo);
        }else{
            POJODetailedAnnouncement pojo = gson.fromJson(response.body().charStream(), POJODetailedAnnouncement.class);
            cOnResponse.onPOJOResponse(pojo);
        }

    }
}
