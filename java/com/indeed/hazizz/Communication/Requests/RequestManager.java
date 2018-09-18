package com.indeed.hazizz.Communication.Requests;

import android.util.Log;

//import com.indeed.hazizz.Communication.RequestInterface;
import com.indeed.hazizz.Communication.SetupInterface;
import com.indeed.hazizz.Communication.Requests.Request;

import org.json.JSONObject;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RequestManager{

    public final String BASE_URL = "http://80.98.42.103:8080/";

    private JSONObject responseJson;
    private JSONObject requestJson;
    private String requestType;
   // private Request requests = new Request();
    private SetupInterface aRequest;

    public RequestManager(String requestType, JSONObject requestBody){
        this.requestType = requestType;
        requestJson = requestBody;
    }

    public JSONObject getJson(){
        return null;
    }



    public void makeCall(){
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        aRequest = retrofit.create(SetupInterface.class);

        Call<JSONObject> call = aRequest.makeCall(requestJson);

       /* HashMap<String, String> headerMap = new HashMap<String, String>();
        headerMap.put("Content-Type", "application/json"); */


       // Call<JSONObject> call = thingRegister.makeCall(requestJson);

        call.enqueue(new Callback<JSONObject>() {
            @Override
            public void onResponse(Call<JSONObject> call, Response<JSONObject> response) {
                responseJson = response.body();
                //    response.body().getTitle();
                // responseHandler.checkErrorCode(response.body().getErrorCode());
                // responseHandler.checkHttpStatus(response.code());
            }

            @Override
            public void onFailure(Call<JSONObject> call, Throwable t) {
                // responseHandler.checkHttpStatus(call.code());
                responseJson = null;
            }
        });
    }

    public JSONObject getResponse(){
        return responseJson;
    }
}
