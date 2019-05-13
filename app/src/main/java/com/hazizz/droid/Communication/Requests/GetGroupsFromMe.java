package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.converter.Converter;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroupsFromMe extends Request {
    public GetGroupsFromMe(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetGroupsFromMe object");
    }
    public void setupCall() {
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getGroupsFromMe(header));
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoGroup>>(){}.getType();
        List<PojoGroup> castedList = Converter.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
