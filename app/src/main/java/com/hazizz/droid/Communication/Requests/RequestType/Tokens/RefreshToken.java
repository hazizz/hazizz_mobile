package com.hazizz.droid.Communication.requests.RequestType.Tokens;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.requests.parent.Request;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.Communication.responsePojos.PojoRefreshToken;
import com.hazizz.droid.other.SharedPrefs;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.manager.ThreadManager;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class RefreshToken extends Request {

    private Context context;

    CustomResponseHandler customResponseHandler = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            PojoRefreshToken PojoRefreshToken = (com.hazizz.droid.Communication.responsePojos.PojoRefreshToken)response;
            SharedPrefs.TokenManager.setRefreshToken(context, PojoRefreshToken.getRefresh());
            SharedPrefs.TokenManager.setToken(context, PojoRefreshToken.getToken());
            ThreadManager.getInstance().unfreezeThread();
            MiddleMan.callAgain();
            Log.e("hey", "got refresh token response");
        }
        @Override
        public void onErrorResponse(PojoError error) {
            if(error.getErrorCode() == 21){
                MiddleMan.cancelAllRequest();
                Transactor.authActivity(context);
            }
        }
    };

    public RefreshToken(Activity act) {
        super(act, null);
        context = act;
        Log.e("hey", "created RefreshToken");
    }
    public RefreshToken(Context context) {
        super();
        this.context = context;
    }

    public void setupCall() {

        headerMap.put("Content-Type", "application/json");
        HashMap<String, Object> body = new HashMap<>();
        body.put("username", SharedPrefs.getString(context, "userInfo", "username"));
        body.put("refreshToken", SharedPrefs.TokenManager.getRefreshToken(context));
        call = aRequest.refreshToken(headerMap, body);
    }
    @Override
    public void makeCall() { independentCall(context,  thisRequest, call, cOnResponse, gson); }
    @Override
    public void makeCallAgain() { callAgain(act,  thisRequest, call, customResponseHandler, gson); }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        PojoRefreshToken pojo = gson.fromJson(response.body().charStream(), PojoRefreshToken.class);
        customResponseHandler.onPOJOResponse(pojo);
    }
}