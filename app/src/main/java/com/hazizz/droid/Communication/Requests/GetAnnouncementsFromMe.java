package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.announcementPojos.PojoAnnouncement;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetAnnouncementsFromMe extends Request {
    public GetAnnouncementsFromMe(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetAnnouncementsFromMe object");
    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getMyAnnouncements(headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {


        Type listType = new TypeToken<ArrayList<PojoAnnouncement>>(){}.getType();

        List<PojoAnnouncement> castedList = null;
        try {
            String rawResponseBody = response.body().string();
            castedList = gson.fromJson(rawResponseBody, listType);
            cOnResponse.getRawResponseBody(rawResponseBody);
        } catch (IOException e) {
            e.printStackTrace();
        }

        cOnResponse.onPOJOResponse(castedList);
    }
}
