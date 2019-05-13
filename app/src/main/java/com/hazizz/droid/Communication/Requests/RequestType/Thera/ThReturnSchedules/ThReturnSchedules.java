package com.hazizz.droid.communication.requests.RequestType.Thera.ThReturnSchedules;

import android.content.Context;
import android.util.Log;

import com.google.gson.reflect.TypeToken;


import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.ThRequest;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.listviews.TheraReturnSchedules.ClassItem;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThReturnSchedules extends ThRequest {
    String p_sessionId, q_weekNumber, q_year;

    String state;

    public ThReturnSchedules(Context context, CustomResponseHandler rh, long p_sessionId, int q_weekNumber, int q_year) {
        super(context, rh);
        Log.e("hey", "created ThReturnGrades object");
        this.p_sessionId = Long.toString(p_sessionId);
        this.q_weekNumber = Integer.toString(q_weekNumber);
        this.q_year = Integer.toString(q_year);
    }

    public void setupCall() {
        putHeaderAuthToken();
        header.put("Accept", HEADER_VALUE_CONTENTTYPE);
      //  call = aRequest.th_returnSchedules(p_sessionId, q_weekNumber, q_year,headerMap);
        buildCall(RequestSender.getTheraRequestTypes().th_returnSchedules(p_sessionId, q_weekNumber, q_year, header));
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoClass>>(){}.getType();
      //  List<PojoClass> castedList2 = Converter.fromJson(response.body().charStream(), listType);

        List<PojoClass> castedList = Converter.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedList);
    }
}

