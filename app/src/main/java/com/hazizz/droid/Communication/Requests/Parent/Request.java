package com.hazizz.droid.Communication.Requests.Parent;

import android.app.Activity;
import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.Pojo;
import com.hazizz.droid.Communication.RequestInterface;
import com.hazizz.droid.Communication.Requests.RequestTypes;
import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;
import com.hazizz.droid.SharedPrefs;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;
import java.util.TreeMap;
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

    public final static String BASE_URL = "https://hazizz.duckdns.org:9000/";
    public final static String BASE_URL_OLD = "https://hazizz.duckdns.org:8081/";

    public final static String BASE_URL2 = "https://hazizz.duckdns.org";
    public final static String BASE_URL_OLD2 = "https://hazizz.duckdns.org";

    private static String HAZIZZ_URL = "https://hazizz.duckdns.org:9000/hazizz-server/";
   // private static final String THERA_URL = "https://hazizz.duckdns.org:9000/thera-server/";

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

    protected Request thisRequest = this;

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

    public Request() {
        Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
        okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(5, TimeUnit.SECONDS)
                .writeTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .build();

        retrofit = new Retrofit.Builder()
                .baseUrl(HAZIZZ_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                //  .setEndpoint(endPoint)F
                .build();

        aRequest = retrofit.create(RequestTypes.class);

        body = new HashMap<>();
        headerMap = new HashMap<>();
    }

    public Request(Activity act, CustomResponseHandler cOnResponse) {
        this.act = act;
        this.context = act;
        this.cOnResponse = cOnResponse;

     //   HAZIZZ_URL = SharedPrefs.Server.getHazizzAddress(getActivity());
         //BASE_URL + "hazizz-server/";//SharedPrefs.Server.getHazizzAddress(getActivity());

        //"https://hazizz.duckdns.org:9000/hazizz-server/"

        Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
        okHttpClient = new OkHttpClient.Builder()
            .connectTimeout(5, TimeUnit.SECONDS)
            .writeTimeout(5, TimeUnit.SECONDS)
            .readTimeout(5, TimeUnit.SECONDS)
            .build();

        retrofit = new Retrofit.Builder()
            .baseUrl(HAZIZZ_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .client(okHttpClient)
            //  .setEndpoint(endPoint)F
            .build();

        aRequest = retrofit.create(RequestTypes.class);

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

    public void makeSyncCall(){ }


    public void cache(String key, String serializedObject){

    }


}

