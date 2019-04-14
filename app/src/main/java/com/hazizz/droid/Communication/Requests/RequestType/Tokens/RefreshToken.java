package com.hazizz.droid.Communication.Requests.RequestType.Tokens;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJORefreshToken;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.Parent.Request;
import com.hazizz.droid.Communication.Requests.RequestTypes;
import com.hazizz.droid.Manager;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;

import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RefreshToken extends Request {

    private Context context;

    CustomResponseHandler customResponseHandler = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            POJORefreshToken pojoRefreshToken = (POJORefreshToken)response;
            SharedPrefs.TokenManager.setRefreshToken(context, pojoRefreshToken.getRefresh());
            SharedPrefs.TokenManager.setToken(context, pojoRefreshToken.getToken());
            Manager.ThreadManager.unfreezeThread();
            MiddleMan.callAgain();
            Log.e("hey", "got refresh token response");
        }
        @Override
        public void onErrorResponse(POJOerror error) {
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
        POJORefreshToken pojo = gson.fromJson(response.body().charStream(), POJORefreshToken.class);
        customResponseHandler.onPOJOResponse(pojo);
    }
}