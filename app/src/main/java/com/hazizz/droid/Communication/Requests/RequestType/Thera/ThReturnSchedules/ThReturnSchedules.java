package com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnSchedules;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Request;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThReturnSchedules extends Request {
    String p_sessionId, q_weekNumber, q_year;

    public ThReturnSchedules(Activity act, CustomResponseHandler rh, int p_sessionId, int q_weekNumber, int q_year) {
        super(act, rh);
        Log.e("hey", "created ThReturnGrades object");
        this.p_sessionId = Integer.toString(p_sessionId);
        this.q_weekNumber = Integer.toString(q_weekNumber);
        this.q_year = Integer.toString(q_year);

    }
    public ThReturnSchedules(Activity act, CustomResponseHandler rh, int p_sessionId, String q_weekNumber, String q_year) {
        super(act, rh);
        Log.e("hey", "created ThReturnGrades object");
        this.p_sessionId = Integer.toString(p_sessionId);
        this.q_weekNumber = q_weekNumber;
        this.q_year = q_year;

    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put("Accept", HEADER_VALUE_CONTENTTYPE);

        call = tRequest.th_returnSchedules(p_sessionId, q_weekNumber, q_year,headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoClass>>(){}.getType();
        List<PojoClass> castedList = gson.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}

