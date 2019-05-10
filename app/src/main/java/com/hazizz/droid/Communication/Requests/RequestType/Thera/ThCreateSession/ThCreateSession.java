package com.hazizz.droid.communication.requests.RequestType.Thera.ThCreateSession;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.ThRequest;
import com.hazizz.droid.communication.requests.RequestType.Thera.PojoSession;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;


import okhttp3.ResponseBody;
import retrofit2.Response;

public class ThCreateSession extends ThRequest {
    public ThCreateSession(Activity act, CustomResponseHandler rh, String b_username, String b_password, String b_url) {
        super(act, rh);
        Log.e("hey", "created ThCreateSession object");

        body.put("username", b_username);
        body.put("password", b_password);
        body.put("url", b_url);

    }
    public void setupCall() {
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
        headerMap.put(HEADER_CONTENTTYPE, HEADER_VALUE_CONTENTTYPE);

        call = aRequest.th_createSession(headerMap, body);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoSession pojo = gson.fromJson(response.body().charStream(), PojoSession.class);
        cOnResponse.onPOJOResponse(pojo);
    }
}
