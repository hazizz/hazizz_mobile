package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJOAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.CommentSectionPOJOs.POJOComment;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJORefreshToken;
import com.hazizz.droid.Communication.POJO.Response.POJOauth;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOgetUser;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOme;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.Communication.POJO.Response.PojoPublicUserData;
import com.hazizz.droid.Communication.POJO.Response.PojoToken;
import com.hazizz.droid.Communication.POJO.Response.PojoType;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.hazizz.droid.Communication.RequestInterface;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Manager;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

import okhttp3.Headers;
import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class Request implements RequestInterface {
    protected Gson gson = new Gson();
    private static final String BASE_URL = "https://hazizz.duckdns.org:8081/";
    private static final String THERA_URL = "https://hazizz.duckdns.org:9000/thera-server/";
   // public RequestInterface requestType;
    protected HashMap<String, Object> body;
    private Retrofit retrofit;
    private Retrofit thera_retrofit;

    protected Call<ResponseBody> call;
    protected RequestTypes aRequest;
    protected RequestTypes tRequest;

    protected CustomResponseHandler cOnResponse;
    protected Activity act;

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

    }


    public void setupCall() {
    }

    public void makeCall() {
    }

    public void makeCallAgain() {
    }

    public void callIsSuccessful(Response<ResponseBody> response) {
    }

}

