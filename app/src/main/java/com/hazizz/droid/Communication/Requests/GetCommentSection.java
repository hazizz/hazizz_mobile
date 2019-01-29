package com.hazizz.droid.Communication.Requests;

import android.content.Context;
import android.util.Log;

import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CommentSectionPOJOs.POJOComment;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.SharedPrefs;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetCommentSection extends Request {
    String p_whereName,p_whereId, p_byName, p_byId;
    GetCommentSection(Context c, CustomResponseHandler rh, Strings.Rank whereName, int whereId, Strings.Rank byName, int byId) {
        super(c, rh);
        Log.e("hey", "created GetMyProfilePic object");
        this.p_whereName = whereName.toString();
        this.p_whereId = Integer.toString(whereId);
        this.p_byName = byName.toString();
        this.p_byId = Integer.toString(byId);
    }

    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

        call = aRequest.getCommentSection(p_whereName,p_byName, p_byId, p_whereId, headerMap);
    }

    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        Type listType = new TypeToken<ArrayList<POJOComment>>(){}.getType();
        List<POJOComment> castedList = gson.fromJson(response.body().charStream(), listType);

        cOnResponse.onPOJOResponse(castedList);
    }
}
