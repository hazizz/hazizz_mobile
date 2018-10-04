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
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Communication.RequestInterface1;
import com.indeed.hazizz.SharedPrefs;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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

  /*  public Request(Context context, String reqType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse){
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
    } */

  /*  public Request(Context context, String reqType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, int groupID){
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
    } */

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
            case "getTasks":
                requestType = new GetTasks();
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

                    if(response.isSuccessful()){ // response != null
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

        Call<Void> call1;

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
            call1.enqueue(new Callback<Void>() {
                @Override
                public void onResponse(Call<Void> call, Response<Void> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.isSuccessful()){ // response != null
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
                public void onFailure(Call<Void> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

    public class Me implements RequestInterface1 {
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

                    if(response.isSuccessful()){ // response != null
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

           // HashMap<String, String> pathMap = new HashMap<String, String>();
           // pathMap.put("id", vars.get("id").toString());
            call1 = aRequest.getGroup(vars.get("id").toString(), headerMap);
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

                    if(response.isSuccessful()){ // response != null
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
            call1 = aRequest.createTask(vars.get("id").toString(), headerMap, body); //Integer.toString(groupID)
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

                    if(response.isSuccessful()){ // response != null
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
        GetSubjects(){
            Log.e("hey", "created Me object");
        }

        Call<List<POJOsubject>> call1;
        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.getSubjects("2", headerMap); // vars.get("id").toString()
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<List<POJOsubject>>() {
                @Override
                public void onResponse(Call<List<POJOsubject>> call, Response<List<POJOsubject>> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.isSuccessful()){ // response != null
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
                public void onFailure(Call<List<POJOsubject>> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

    public class GetTasks implements RequestInterface1 {
        GetTasks(){
            Log.e("hey", "created GetTasks object");
        }

        Call<ArrayList<POJOgetTask>> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.getTasks(vars.get("id").toString(), headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call1.enqueue(new Callback<ArrayList<POJOgetTask>>() {
                @Override
                public void onResponse(Call<ArrayList<POJOgetTask>> call, Response<ArrayList<POJOgetTask>> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.isSuccessful()){ // response != null response.isSuccessful()
                        Log.e("hey", (String)response.body().toString());
                        Log.e("hey", "2");

                        cOnResponse.onPOJOResponse(response.body());
                        Log.e("hey", "3");

                    }
                 /*   if (response.body() instanceof ArrayList<POJOgetTask> )
                    {

                        ArrayList<POJOgetTask> myObj = (MyPOJO) response.body();
                        //handle MyPOJO
                    } */

                 /*   if(response.body() instanceof ArrayList<?>)
                    {
                       // if(((ArrayList<POJOgetTask>)response.body()).get(0) instanceof POJOgetTask){

                         //   ArrayList<POJOgetTask> r = (ArrayList<POJOgetTask>) response.body();
                            POJOgetTask r = (POJOgetTask) ((ArrayList)response.body()).get(0);

                            cOnResponse.onPOJOResponse((Object)r);
                            Log.e("hey", "onPOJOresponse");
                       // }
                    }
                    else  //must be error object
                    {
                      //  MyError myError = (MyError) response.body();
                        //handle error object
                        Log.e("hey", "new thing doesnt work");
                    }
                    Log.e("hey", "right here");
                    */
                }
                @Override
                public void onFailure(Call<ArrayList<POJOgetTask>> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }
}

//TODO THIS WILL SAVE YOUR LIFE!!!
/*
Call.enqueue(new Callback<RegistrationResponse>() {
@Override
public void onResponse(Call<RegistrationResponse> call, Response<RegistrationResponse> response)
        {
        if (response.isSuccessful()) {
        // do your code here
        } else if (response.code() == 400) {
        Converter<ResponseBody, ApiError> converter =
        ApiClient.retrofit.responseBodyConverter(ApiError.class, new Annotation[0]);

        ApiError error;

        try {
        error = converter.convert(response.errorBody());
        Log.e("error message", error.getErrorMessage());
        Toast.makeText(context, error.getErrorMessage(), Toast.LENGTH_LONG).show();
        } catch (IOException e) {
        e.printStackTrace();
        }
        }
        }

@Override
public void onFailure(Call<RegistrationResponse> call, Throwable t) {
        //do your failure handling code here
        }
        }
        */
//TODO THIS WILL SAVE YOUR LIFE!!!
    /*
Call<Object> call = api.login(username, password);
call.enqueue(new Callback<Object>()
        {
@Override
public void onResponse(Response<Object> response, Retrofit retrofit)
        {
        if (response.body() instanceof MyPOJO )
        {
        MyPOJO myObj = (MyPOJO) response.body();
        //handle MyPOJO
        }
        else  //must be error object
        {
        MyError myError = (MyError) response.body();
        //handle error object
        }
        }

@Override
public void onFailure(Throwable t)
        {
        ///Handle failure
        }
        });
*/
