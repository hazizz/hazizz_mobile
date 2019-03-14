package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.hazizz.droid.Communication.Requests.Parent.Request;
import com.hazizz.droid.Communication.Strings;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetAT extends Request {
    private String p_whereName;
    private String p_whereId;
    public GetAT(Activity act, CustomResponseHandler rh, Strings.Path p_whereName, int p_whereId) {
        super(act, rh);
        Log.e("hey", "created GetAT object");
        this.p_whereName = p_whereName.toString();
        this.p_whereId = Integer.toString(p_whereId);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());

        call = aRequest.getAT(p_whereName, p_whereId, headerMap);
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
