package com.hazizz.droid.Communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoGroup;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class GetGroup extends Request {
    private int p_groupId;
    public GetGroup(Activity act, CustomResponseHandler rh, int p_groupId) {
        super(act, rh);
        Log.e("hey", "created GetGroup object");
        this.p_groupId = p_groupId;
    }


    public void setupCall() {

        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        call = aRequest.getGroup(Integer.toString(p_groupId), headerMap);
    }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {

        PojoGroup PojoGroup = gson.fromJson(response.body().charStream(), PojoGroup.class);
        cOnResponse.onPOJOResponse(PojoGroup);
    }
}
