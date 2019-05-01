package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.announcementPojos.PojoAnnouncementDetailed;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoTaskDetailed;

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
             PojoTaskDetailed pojo = gson.fromJson(response.body().charStream(),  PojoTaskDetailed.class);
            cOnResponse.onPOJOResponse(pojo);
        }else{
            PojoAnnouncementDetailed pojo = gson.fromJson(response.body().charStream(), PojoAnnouncementDetailed.class);
            cOnResponse.onPOJOResponse(pojo);
        }

    }
}
