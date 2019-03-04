package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.RequestInterface;
import com.hazizz.droid.SharedPrefs;

import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class Request implements RequestInterface {
    protected Gson gson = new Gson();
    protected Activity act;
    private static final String BASE_URL = "https://hazizz.duckdns.org:8081/";
    private static final String THERA_URL = "https://hazizz.duckdns.org:9000/thera-server/";

    protected static final String HEADER_AUTH = "Authorization";
    protected static final String HEADER_CONTENTTYPE = "Content-Type";
    protected static final String HEADER_VALUE_CONTENTTYPE = "application/json";




    protected String getHeaderAuthToken(){return "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext());}
    protected String getHeaderAuthToken(Context context){return "Bearer " + SharedPrefs.TokenManager.getToken(context);}


    protected HashMap<String, String> headerMap;
    protected HashMap<String, Object> body;
    private Retrofit retrofit;
    private Retrofit thera_retrofit;

    protected Call<ResponseBody> call;
    protected RequestTypes aRequest;
    protected RequestTypes tRequest;

    protected CustomResponseHandler cOnResponse;

    protected Request thisRequest = this;

    private OkHttpClient okHttpClient;

    public Activity getActivity(){
        return act;
    }

    public CustomResponseHandler getResponseHandler(){
        return cOnResponse;
    }

    public void cancelRequest() {
        okHttpClient.dispatcher().cancelAll();
        this.call.cancel();
    }

    public Request(Activity act, CustomResponseHandler cOnResponse) {
        this.act = act;
        this.cOnResponse = cOnResponse;
        Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
        okHttpClient = new OkHttpClient.Builder()
            .connectTimeout(5, TimeUnit.SECONDS)
            .writeTimeout(5, TimeUnit.SECONDS)
            .readTimeout(5, TimeUnit.SECONDS)
            .build();

        retrofit = new Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .client(okHttpClient)
            //  .setEndpoint(endPoint)F
            .build();

        thera_retrofit = new Retrofit.Builder()
            .baseUrl(THERA_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .client(okHttpClient)
            .build();

        aRequest = retrofit.create(RequestTypes.class);
        tRequest = thera_retrofit.create(RequestTypes.class);

        body = new HashMap<>();
        headerMap = new HashMap<>();
    }

    @Override
    public void makeCall() {
        call(act,  thisRequest, call, cOnResponse, gson);
    }

    @Override
    public void makeCallAgain() {
        callAgain(act,  thisRequest, call, cOnResponse, gson);
    }

    public void setupCall() { }

    public void callIsSuccessful(Response<ResponseBody> response) { }
}

