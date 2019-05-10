package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTask;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetMyTasks  extends Request {
    public GetMyTasks(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created GetMyTasks object");
    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getMyTasks(headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList< PojoTask>>(){}.getType();
        List<PojoTask> castedList = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);

    }
}
