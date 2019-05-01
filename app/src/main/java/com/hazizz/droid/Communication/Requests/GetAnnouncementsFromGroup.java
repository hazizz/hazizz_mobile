package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.announcementPojos.PojoAnnouncement;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetAnnouncementsFromGroup extends Request {
    String groupId;
    public GetAnnouncementsFromGroup(Activity act, CustomResponseHandler rh, int groupId) {
        super(act, rh);
        Log.e("hey", "created GetAnnouncements object");
        this.groupId = Integer.toString(groupId);
    }
    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getAnnouncementsFromGroup(groupId, headerMap);
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoAnnouncement>>(){}.getType();
        List<PojoAnnouncement> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
        Log.e("hey", "size of response list: " + castedList.size());
    }
}
