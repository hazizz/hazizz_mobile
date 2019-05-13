package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.announcementPojos.PojoAnnouncement;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.converter.Converter;

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

        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getAnnouncementsFromGroup(groupId, header));

    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoAnnouncement>>(){}.getType();
        List<PojoAnnouncement> castedList = Converter.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
        Log.e("hey", "size of response list: " + castedList.size());
    }
}
