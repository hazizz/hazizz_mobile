package com.indeed.hazizz.Communication.Requests;

import android.content.Context;
import android.util.Log;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOcreateTask;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Communication.POJO.Response.POJOregister;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubjects;
import com.indeed.hazizz.Communication.RequestInterface1;
import com.indeed.hazizz.SharedPrefs;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.http.Path;

public class Request {

    public final String BASE_URL = "https://hazizz.duckdns.org:8081/";
    public RequestInterface1 requestType;

    public  HashMap<String, Object> response1;
    private HashMap<String, Object> body;

    private Retrofit retrofit;

    Call<HashMap<String, Object>>  call;
    Call<ResponseBody>  call2;
    RequestTypes aRequest;

    CustomResponseHandler cOnResponse;
    Context context;

    int groupID;

    private HashMap<String, Object> vars;

    public Request(Context context, String reqType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars){
        this.cOnResponse = cOnResponse;
        this.body = body;
        this.context = context;
        this.vars = vars;

        Gson gson = new GsonBuilder().serializeNulls().create();

        retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build();

        findRequestType(reqType);
        aRequest = retrofit.create(RequestTypes.class);
    }

    public Request(Context context, String reqType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse){
        this.cOnResponse = cOnResponse;
        this.body = body;
        this.context = context;

        Gson gson = new GsonBuilder().serializeNulls().create();

        retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build();

        findRequestType(reqType);
        aRequest = retrofit.create(RequestTypes.class);
    }

    public Request(Context context, String reqType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, int groupID){
        this.cOnResponse = cOnResponse;
        this.body = body;
        this.context = context;
        this.groupID = groupID;

        Gson gson = new GsonBuilder().serializeNulls().create();

        retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build();

        findRequestType(reqType);
        aRequest = retrofit.create(RequestTypes.class);
    }

    public void findRequestType(String reqType){
        switch(reqType){
            case "register":
                requestType = new Register();
                break;
            case "login":
                requestType = new Login();
                break;
            case "me":
                requestType = new Me();
                break;
            case "getGroup":
                requestType = new GetGroup();
                break;
            case "createTask":
                requestType = new CreateTask();
                break;
            case "getSubjects":
                requestType = new GetSubjects();
                break;
        }
    }

    public HashMap<String, Object>  getResponse(){
        return response1;
    }

    public class Login implements RequestInterface1 {
        //   public String name = "register";
        Login(){
            Log.e("hey", "created Login object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");

            HashMap<String, Object> body = new HashMap<String, Object>();
            body.put("username", "bela");
            body.put("password", "sasasajt");

            //  Log.e("hey", requestJson.toString());
            call = aRequest.login(headerMap, body);
        }

        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<HashMap<String, Object> >() {
                @Override
                public void onResponse(Call<HashMap<String, Object>> call, Response<HashMap<String, Object>> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.body() != null){ // response != null
                        Log.e("hey", (String)response.body().toString());
                        if(response.body().containsKey("errorCode")) {
                            cOnResponse.onErrorResponse(response.body());
                            Log.e("hey", "2");
                        }else{
                            response1 = response.body();
                            cOnResponse.onResponse(response1);
                            Log.e("hey", "3");
                        }
                    }else {
                        try {
                            String strError = response.errorBody().string();
                            JSONObject errorJson = new JSONObject(strError);
                            HashMap<String, Object> errorResponse = new HashMap<String, Object>();

                            errorResponse.put("time", String.valueOf(errorJson.get("time")));
                            errorResponse.put("errorCode", String.valueOf(errorJson.get("errorCode")));
                            errorResponse.put("title", String.valueOf(errorJson.get("title")));
                            errorResponse.put("message", String.valueOf(errorJson.get("message")));

                            cOnResponse.onErrorResponse(errorResponse);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    // Log.e("hey", "errorCode : " + response.errorBody().get("errorCode"));

                    //   Log.e("hey", "errorCode is : " + response.body().getErrorCode());
                    // responseHandler.checkErrorCode(response.body().getErrorCode());
                    // responseHandler.checkHttpStatus(response.code());

                }
                @Override
                public void onFailure(Call<HashMap<String, Object>> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

    public class Register implements RequestInterface1 {
        Register(){
            Log.e("hey", "created");
        }

        Call<POJOregister> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            call1 = aRequest.register(headerMap, body);
        }

        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<POJOregister>() {
                @Override
                public void onResponse(Call<POJOregister> call, Response<POJOregister> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.body() != null){ // response != null
                 /*       Log.e("hey", (String)response.body().toString());
                        if(response.body().containsKey("errorCode")) {
                            cOnResponse.onErrorResponse(response.body());
                            Log.e("hey", "2");
                        }else{
                            response1 = response.body();
                            cOnResponse.onResponse(response1);
                            Log.e("hey", "3");
                        } */
                    }else {
                        try {
                            String strError = response.errorBody().string();
                            JSONObject errorJson = new JSONObject(strError);
                            HashMap<String, Object> errorResponse = new HashMap<String, Object>();

                            errorResponse.put("time", String.valueOf(errorJson.get("time")));
                            errorResponse.put("errorCode", String.valueOf(errorJson.get("errorCode")));
                            errorResponse.put("title", String.valueOf(errorJson.get("title")));
                            errorResponse.put("message", String.valueOf(errorJson.get("message")));

                            cOnResponse.onErrorResponse(errorResponse);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
                @Override
                public void onFailure(Call<POJOregister> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

    public class Me implements RequestInterface1 {
        //   public String name = "register";
        Me(){
            Log.e("hey", "created Me object");
        }

        Call<POJOme> call1;
        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.me(headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<POJOme>() {
                @Override
                public void onResponse(Call<POJOme> call, Response<POJOme> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.body() != null){ // response != null
                        Log.e("hey", (String)response.body().toString());
                        Log.e("hey", "2");

                        cOnResponse.onPOJOResponse(response.body());
                        Log.e("hey", "3");
                    }
                    else if(false){
                        try {
                            String strError = response.errorBody().string();
                            JSONObject errorJson = new JSONObject(strError);
                            HashMap<String, Object> errorResponse = new HashMap<String, Object>();

                            errorResponse.put("time", String.valueOf(errorJson.get("time")));
                            errorResponse.put("errorCode", String.valueOf(errorJson.get("errorCode")));
                            errorResponse.put("title", String.valueOf(errorJson.get("title")));
                            errorResponse.put("message", String.valueOf(errorJson.get("message")));

                            cOnResponse.onErrorResponse(errorResponse);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
                @Override
                public void onFailure(Call<POJOme> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

    public class GetGroup implements RequestInterface1 {
        //   public String name = "register";
        GetGroup(){
            Log.e("hey", "created GetGroup object");
        }

        Call<POJOgroup> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));

            HashMap<String, String> pathMap = new HashMap<String, String>();
            pathMap.put("id", Integer.toString(groupID));
            call1 = aRequest.getGroup(Integer.toString(groupID), headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<POJOgroup>() {
                @Override
                public void onResponse(Call<POJOgroup> call, Response<POJOgroup> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.body() != null){ // response != null
                        Log.e("hey", (String)response.body().toString());
                        Log.e("hey", "2");

                        cOnResponse.onPOJOResponse(response.body());
                        Log.e("hey", "3");
                    }
                    else if(false){
                        try {
                            String strError = response.errorBody().string();
                            JSONObject errorJson = new JSONObject(strError);
                            HashMap<String, Object> errorResponse = new HashMap<String, Object>();

                            errorResponse.put("time", String.valueOf(errorJson.get("time")));
                            errorResponse.put("errorCode", String.valueOf(errorJson.get("errorCode")));
                            errorResponse.put("title", String.valueOf(errorJson.get("title")));
                            errorResponse.put("message", String.valueOf(errorJson.get("message")));

                            cOnResponse.onErrorResponse(errorResponse);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
                @Override
                public void onFailure(Call<POJOgroup> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

 /*   public class CreateTask1 implements RequestInterface1{

        Call<Void> call1;

        CreateTask1(){
            Log.e("hey", "created CreateTask object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
          //  headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.createTask( headerMap, body); //Integer.toString(groupID)
        }

        @Override
        public Object getResponse() {
            return null;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "wow a response");
                }

                @Override
                public void onFailure(Call<Void> call, Throwable t) {
                    Log.e("hey", "wow onfailure");
                }
            });
        }
    } */

    public class CreateTask implements RequestInterface1 {
        //   public String name = "register";
        CreateTask(){
            Log.e("hey", "created CreateTask object");
        }

        Call<POJOerror> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.createTask(headerMap, body); //Integer.toString(groupID)
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<POJOerror>() {
                @Override
                public void onResponse(Call<POJOerror> call, Response<POJOerror> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());
                    Log.e("hey", "status code: " + response.code());
                    Log.e("hey", "title: " +response.body().getTitle());
                    Log.e("hey", "message: " + response.body().getMessage());

                    if(response.body() != null){ // response != null
                        Log.e("hey", (String)response.body().toString());
                        Log.e("hey", "2");

                        cOnResponse.onPOJOResponse(response.body());
                        Log.e("hey", "3");
                    }
                    else if(false){
                        try {
                            String strError = response.errorBody().string();
                            JSONObject errorJson = new JSONObject(strError);
                            HashMap<String, Object> errorResponse = new HashMap<String, Object>();

                            errorResponse.put("time", String.valueOf(errorJson.get("time")));
                            errorResponse.put("errorCode", String.valueOf(errorJson.get("errorCode")));
                            errorResponse.put("title", String.valueOf(errorJson.get("title")));
                            errorResponse.put("message", String.valueOf(errorJson.get("message")));

                            cOnResponse.onErrorResponse(errorResponse);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
                @Override
                public void onFailure(Call<POJOerror> call, Throwable t) {
                    Log.e("hey", call.toString());
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }
    public class GetSubjects implements RequestInterface1 {
        //   public String name = "register";
        GetSubjects(){
            Log.e("hey", "created Me object");
        }

        Call<ResponseBody> call1;
        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.getSubjects("2", headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.body() != null){ // response != null
                        Log.e("hey", (String)response.body().toString());
                        Log.e("hey", "2");

                        cOnResponse.onPOJOResponse(response.body());
                        Log.e("hey", "3");
                    }
                    else if(false){
                        try {
                            String strError = response.errorBody().string();
                            JSONObject errorJson = new JSONObject(strError);
                            HashMap<String, Object> errorResponse = new HashMap<String, Object>();

                            errorResponse.put("time", String.valueOf(errorJson.get("time")));
                            errorResponse.put("errorCode", String.valueOf(errorJson.get("errorCode")));
                            errorResponse.put("title", String.valueOf(errorJson.get("title")));
                            errorResponse.put("message", String.valueOf(errorJson.get("message")));

                            cOnResponse.onErrorResponse(errorResponse);

                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

}
