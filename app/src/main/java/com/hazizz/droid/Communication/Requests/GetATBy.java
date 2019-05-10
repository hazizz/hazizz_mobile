package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.Strings;
import com.hazizz.droid.communication.responsePojos.announcementPojos.PojoAnnouncementDetailed;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTaskDetailed;

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
             PojoTaskDetailed pojo = gson.fromJson(response.body().charStream(),  PojoTaskDetailed.class);
            cOnResponse.onPOJOResponse(pojo);
        }else{
            PojoAnnouncementDetailed pojo = gson.fromJson(response.body().charStream(), PojoAnnouncementDetailed.class);
            cOnResponse.onPOJOResponse(pojo);
        }

    }
}
