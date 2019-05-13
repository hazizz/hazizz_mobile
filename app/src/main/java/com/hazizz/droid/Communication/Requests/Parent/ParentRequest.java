package com.hazizz.droid.communication.requests.parent;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hazizz.droid.R;
import com.hazizz.droid.communication.ErrorCode;
import com.hazizz.droid.communication.MiddleMan;
import com.hazizz.droid.communication.RequestInterface;
import com.hazizz.droid.communication.requests.RequestType.Tokens.RefreshToken;
import com.hazizz.droid.communication.requests.RequestTypes;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.manager.ThreadManager;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.other.SharedPrefs;

import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ParentRequest implements RequestInterface {


    protected Context context;
    public Context getContext(){
        return context;
    }

    private String PATH = "";

   // private static String HAZIZZ_URL = "https://hazizz.duckdns.org:9000/hazizz-server/";
    protected static final String HEADER_AUTH = "Authorization";
    protected static final String HEADER_CONTENTTYPE = "Content-Type";
    protected static final String HEADER_VALUE_CONTENTTYPE = "application/json";


    protected String getHeaderAuthToken(){
        return "Bearer " + SharedPrefs.TokenManager.getToken(context);
    }
    protected String getHeaderAuthToken(Context context){
        return "Bearer " + SharedPrefs.TokenManager.getToken(context);
    }


    protected HashMap<String, String> header;
    protected HashMap<String, Object> body;


    protected Call<ResponseBody> call;

    public Call<ResponseBody> getCall(){
        return call;
    }

 //   protected RequestTypes aRequest;
    protected RequestTypes tRequest;

    public Gson gson;

    protected CustomResponseHandler cOnResponse;
    public CustomResponseHandler getOnResponse(){
        return cOnResponse;
    }

    protected ParentRequest thisRequest = this;



    public CustomResponseHandler getResponseHandler(){
        return cOnResponse;
    }

    public void cancelRequest() {
      //  okHttpClient.dispatcher().cancelAll();
        if(this.call != null) {
            this.call.cancel();
        }
    }


    protected ParentRequest(String path) {
        this.PATH = path;



        gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
        /*
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

        */

       // aRequest = retrofit.create(RequestTypes.class);

        body = new HashMap<>();
        header = new HashMap<>();
    }

    protected ParentRequest(Context context, CustomResponseHandler cOnResponse, String path) {
        this.context = context;
        this.cOnResponse = cOnResponse;
        this.PATH = path;


        gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
        /*
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
        */

       // aRequest = RequestSender.retrofit.create(RequestTypes.class);


        body = new HashMap<>();
        header = new HashMap<>();
    }

    protected void putHeaderContentType(){
        header.put("Content-Type", "application/json");
    }

    protected void putHeaderAuthToken(){
        header.put(HEADER_AUTH, "Bearer " + SharedPrefs.TokenManager.getToken(context));
    }

    @Override
    public void makeCall() {
        call();
    }

    public void makeAsyncCall(){

    }


    @Override
    public void makeCallAgain() {
        callAgain();
    }

    public void setupCall() { }

    public void callIsSuccessful(Response<ResponseBody> response) { }

    public void makeSyncCall(){ }



    public void cache(String key, String serializedObject){ }


    @Override
    public void call(){
        call.enqueue(buildCallback());
    }

    @Override
    public void callAgain(){
        call.clone().enqueue(buildCallback());
        Log.e("hey", "CALL AGAIN");
    }

    public Callback<ResponseBody> buildCallback(){
        Callback<ResponseBody> callback = new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                processResponse(response);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                if(cOnResponse != null) {
                    cOnResponse.onFailure(call, t);
                }
                Toast.makeText(context, R.string.info_something_went_wrong, Toast.LENGTH_LONG).show();
            }
        };
        return callback;
    }

    @Override
    public void processResponse(Response<ResponseBody> response) {

    }

    protected void buildCall(Call<ResponseBody> call){
        this.call = call;
    }

}

