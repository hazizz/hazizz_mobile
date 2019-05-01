package com.hazizz.droid.Communication.requests.parent;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hazizz.droid.Communication.requests.RequestTypes;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RequestSender {

    Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
    OkHttpClient okHttpClient = new OkHttpClient.Builder()
            .connectTimeout(5,TimeUnit.SECONDS)
                .writeTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .build();

    Retrofit retrofit = new Retrofit.Builder()
            .baseUrl("THERA_URL")
            .addConverterFactory(GsonConverterFactory.create(gson))
            .client(okHttpClient)
    //  .setEndpoint(endPoint)F
                .build();

    RequestTypes aRequest = retrofit.create(RequestTypes.class);


    public void send(Request request){

    }


}
