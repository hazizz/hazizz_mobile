package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoSubject;

import java.lang.reflect.Type;
import java.util.ArrayList;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetSubjects extends Request {
    String p_groupId;
    public GetSubjects(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created GetSubjects object");
        this.p_groupId = Integer.toString(p_groupId);
    }


    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getSubjects(p_groupId, headerMap); // vars.get(id").toString()
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList< PojoSubject>>(){}.getType();
        ArrayList<PojoSubject> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}
