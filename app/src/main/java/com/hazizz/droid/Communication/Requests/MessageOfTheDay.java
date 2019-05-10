package com.hazizz.droid.communication.requests;

import android.app.Activity;
import android.util.Log;


import com.hazizz.droid.communication.requests.parent.Request;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;

import java.io.IOException;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class MessageOfTheDay extends Request {
    public MessageOfTheDay(Activity act, CustomResponseHandler rh) {
        super(act, rh);
        Log.e("hey", "created MessageOfTheDay object");
    }

    public void setupCall() {
        call = aRequest.messageOfTheDay();
    }

    @Override
    public void makeCall() {
        call(act, thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void makeCallAgain() {
        callAgain(act, thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
       /* Type listType = new TypeToken<HashMap<Integer, PojoMembersProfilePic>>(){}.getType();
        HashMap<Integer, PojoMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
        cOnResponse.onPOJOResponse(castedMap);
        Log.e("hey", "size of response map: " + castedMap.size());*/
        try {
            String r = response.body().string();
            cOnResponse.onPOJOResponse(r.substring(1, r.length() - 1));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
