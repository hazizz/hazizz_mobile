package com.hazizz.droid.communication.requests.parent;

import android.app.Activity;
import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hazizz.droid.communication.RequestInterface;
import com.hazizz.droid.communication.requests.RequestTypes;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.other.SharedPrefs;

import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ParentRequest implements RequestInterface {
    protected Gson gson = new Gson();
    protected Activity act;

    public static final String BASE_URL = "https://hazizz.duckdns.org:9000/";

    private String PATH = "";

   // private static String HAZIZZ_URL = "https://hazizz.duckdns.org:9000/hazizz-server/";
    protected static final String HEADER_AUTH = "Authorization";
    protected static final String HEADER_CONTENTTYPE = "Content-Type";
    protected static final String HEADER_VALUE_CONTENTTYPE = "application/json";


    protected String getHeaderAuthToken(){return "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext());}
    protected String getHeaderAuthToken(Context context){return "Bearer " + SharedPrefs.TokenManager.getToken(context);}


    protected HashMap<String, String> headerMap;
    protected HashMap<String, Object> body;
    protected Retrofit retrofit;

    protected Call<ResponseBody> call;
    protected RequestTypes aRequest;
    protected RequestTypes tRequest;

    protected CustomResponseHandler cOnResponse;

    protected ParentRequest thisRequest = this;

    protected OkHttpClient okHttpClient;

    protected Context context;

    public Activity getActivity(){
        return act;
    }

    public CustomResponseHandler getResponseHandler(){
        return cOnResponse;
    }

    public void cancelRequest() {
        okHttpClient.dispatcher().cancelAll();
        if(this.call != null) {
            this.call.cancel();
        }
    }

    protected ParentRequest(String path) {
        this.PATH = path;

        Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
        okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(5, TimeUnit.SECONDS)
                .writeTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .build();

        retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL + PATH)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                //  .setEndpoint(endPoint)F
                .build();

        aRequest = retrofit.create(RequestTypes.class);

        body = new HashMap<>();
        headerMap = new HashMap<>();
    }

    protected ParentRequest(Activity act, CustomResponseHandler cOnResponse, String path) {
        this.act = act;
        this.context = act;
        this.cOnResponse = cOnResponse;
        this.PATH = path;

        Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
        okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(5, TimeUnit.SECONDS)
                .writeTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .build();

        retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL + PATH)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                //  .setEndpoint(endPoint)F
                .build();

        aRequest = retrofit.create(RequestTypes.class);

        body = new HashMap<>();
        headerMap = new HashMap<>();
    }

    protected void putHeaderContentType(){
        headerMap.put("Content-Type", "application/json");
    }

    protected void putHeaderAuthToken(){
        headerMap.put(HEADER_AUTH, getHeaderAuthToken());
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

    public void makeSyncCall(){ }

    public void makeAsyncCall(){}

    public void cache(String key, String serializedObject){

    }


}

