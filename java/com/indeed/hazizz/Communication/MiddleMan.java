package com.indeed.hazizz.Communication;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
//import com.indeed.hazizz.Communication.POJO.ParentPOJO;
import com.indeed.hazizz.Communication.POJO.Requests.RequestInterface;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.ResponseInterface;
import com.indeed.hazizz.Communication.Requests.Request;

import org.json.JSONObject;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class MiddleMan{

    private Request newRequest;
    private String requestType;
    public MiddleMan(Context context, String requestType, HashMap<String, Object>  pp, CustomResponseHandler cOnResponse) {
        this.requestType = requestType;
        newRequest = new Request(context, requestType, pp, cOnResponse);
    }

    public MiddleMan(Context context, String requestType, HashMap<String, Object>  pp, CustomResponseHandler cOnResponse, int groupID) {
        this.requestType = requestType;
        newRequest = new Request(context, requestType, pp, cOnResponse, groupID);
    }

    public void sendRequest() {
        newRequest.requestType.setupCall();
        newRequest.makeCall();
    }

    public void sendRequest2() {
        newRequest.requestType.setupCall();
        newRequest.requestType.makeCall();
    }

    public HashMap<String, Object>  getResponse() {
        return newRequest.getResponse();
    }
    public void getResponse1() {
        try {
            String a = newRequest.getResponse().toString();
            Log.e("hey", newRequest.getResponse().toString() + "yes");
        }catch (NullPointerException e){
            Log.e("hey", "not abble to: " + e.toString());
        }
    }
}
