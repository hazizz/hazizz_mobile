package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.Parent.Request;

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
       /* Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
        HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
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
