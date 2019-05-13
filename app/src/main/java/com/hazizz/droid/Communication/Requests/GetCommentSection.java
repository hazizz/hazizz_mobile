package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;

import com.google.gson.reflect.TypeToken;

import com.hazizz.droid.communication.RequestSender;
import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.commentSectionPojos.PojoComment;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.converter.Converter;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetCommentSection extends Request {
    String p_whereName,p_whereId;
    public GetCommentSection(Activity act, CustomResponseHandler rh, String whereName, int whereId) {
        super(act, rh);
        Log.e("hey", "created GetCommentSection object");
        this.p_whereName = whereName.toString();
        this.p_whereId = Integer.toString(whereId);
    }

    public void setupCall() {
        putHeaderAuthToken();
        buildCall(RequestSender.getHazizzRequestTypes().getCommentSection(p_whereName, p_whereId, header));
    }


    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<PojoComment>>(){}.getType();
        List<PojoComment> castedList = Converter.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}
