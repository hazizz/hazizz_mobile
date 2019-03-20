package com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnGrades;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.ThRequest;
import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThReturnGrades extends ThRequest {
    String p_sessionId;

    public ThReturnGrades(Activity act, CustomResponseHandler rh, int p_sessionId) {
        super(act, rh);
        Log.e("hey", "created ThReturnGrades object");
        this.p_sessionId = Integer.toString(p_sessionId);

    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put("Accept", HEADER_VALUE_CONTENTTYPE);

        call = aRequest.th_returnGrades(p_sessionId ,headerMap);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<HashMap<String, List<TheraGradesItem>>>(){}.getType();
        HashMap<String, List<TheraGradesItem>> castedMap = gson.fromJson(response.body().charStream(), listType);
        Log.e("hey", "grade: " + castedMap.get("angol nyelv").get(0).getWeight());
        cOnResponse.onPOJOResponse(castedMap);
    }
}
