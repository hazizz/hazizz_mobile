package com.hazizz.droid.Communication.Requests.RequestType.Tokens;

import android.app.Activity;
import android.util.Log;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJORefreshToken;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.Manager;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class RefreshToken extends Request {
    CustomResponseHandler customResponseHandler = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            POJORefreshToken pojoRefreshToken = (POJORefreshToken)response;
            SharedPrefs.TokenManager.setRefreshToken(act.getBaseContext(), pojoRefreshToken.getRefresh());
            SharedPrefs.TokenManager.setToken(act.getBaseContext(), pojoRefreshToken.getToken());
            Manager.ThreadManager.unfreezeThread();
            MiddleMan.callAgain();
        }
        @Override
        public void onErrorResponse(POJOerror error) {
            if(error.getErrorCode() == 21){
                MiddleMan.cancelAllRequest();
                Transactor.AuthActivity(act);
            }
        }
    };

    public RefreshToken(Activity act) {
        super(act, null);
        Log.e("hey", "created RefreshToken");
    }
    public void setupCall() {
        HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Content-Type", "application/json");
        HashMap<String, Object> body = new HashMap<>();
        body.put("username", SharedPrefs.getString(act.getBaseContext(), "userInfo", "username"));
        body.put("refreshToken", SharedPrefs.TokenManager.getRefreshToken(act.getBaseContext()));

        call = aRequest.refreshToken(headerMap, body);
    }
    @Override
    public void makeCall() { call(act,  thisRequest, call, cOnResponse, gson); }
    @Override
    public void makeCallAgain() { callAgain(act,  thisRequest, call, customResponseHandler, gson); }
    @Override
    public void callIsSuccessful(Response<ResponseBody> response) {
        POJORefreshToken pojo = gson.fromJson(response.body().charStream(), POJORefreshToken.class);
        customResponseHandler.onPOJOResponse(pojo);
    }
}