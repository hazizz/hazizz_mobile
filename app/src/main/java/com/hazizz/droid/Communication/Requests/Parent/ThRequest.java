package com.hazizz.droid.communication.requests.parent;

import android.app.Activity;
import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import com.hazizz.droid.communication.RequestInterface;
import com.hazizz.droid.communication.requests.RequestTypes;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.other.SharedPrefs;

import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ThRequest extends ParentRequest {

    private static final String path = "thera-server/";

    public ThRequest(){
        super(path);
        this.thisRequest = this;
    }
    public ThRequest(Activity act, CustomResponseHandler cOnResponse){
        super(act, cOnResponse, path);
        this.thisRequest = this;
    }

    public ThRequest(Context context, CustomResponseHandler cOnResponse){
        super(path);
        this.thisRequest = this;
    }

}

