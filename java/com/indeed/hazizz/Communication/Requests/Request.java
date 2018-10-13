package com.indeed.hazizz.Communication.Requests;

import android.content.Context;
import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.reflect.TypeToken;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOauth;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgetUser;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.indeed.hazizz.Communication.RequestInterface1;
import com.indeed.hazizz.SharedPrefs;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;


public class Request {

    private Gson gson = new Gson();

    public final String BASE_URL = "https://hazizz.duckdns.org:8081/";
    public RequestInterface1 requestType;

    public  HashMap<String, Object> response1;
    private HashMap<String, Object> body;

    private Retrofit retrofit;

    Call<ResponseBody>  call;
 //   Call<ResponseBody>  call2;
    RequestTypes aRequest;

    CustomResponseHandler cOnResponse;
    Context context;


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
            case "getTasksFromMe":
                requestType = new GetTasksFromMe();
                break;
            case "getTasksFromGroup":
                requestType = new GetTasksFromGroup();
                break;
            case "getTask":
                requestType = new GetTask();
                break;
            case "getUsers":
                requestType = new GetUsers();
                break;
            case "getTask1":
                requestType = new GetTask();
                break;
            case "getGroupsFromMe":
                requestType = new GetGroupsFromMe();
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

            HashMap<String, String> b = new HashMap<>();
          //  body.put("username", "bela");
         //   body.put("password", "sasasajt");
            b.put("username", body.get("username").toString());
            b.put("password", body.get("password").toString());
            call = aRequest.login(headerMap, b);
        }

        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.body() == null){
                        Log.e("hey", "response is null ");
                    }
                   /* if(response.body().toString() == ""){
                        Log.e("hey", "response is blank ");
                    } */

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        POJOauth pojoAuth = gson.fromJson(response.body().charStream(),POJOauth.class);

                        cOnResponse.onPOJOResponse(pojoAuth);
                    }

                    if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onNoResponse();}
                    // Log.e("hey", "errorCode : " + response.errorBody().get("errorCode"));

                    //   Log.e("hey", "errorCode is : " + response.body().getErrorCode());
                    // responseHandler.checkErrorCode(response.body().getErrorCode());
                    // responseHandler.checkHttpStatus(response.code());

                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
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


        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            call = aRequest.register(headerMap, body);
        }

        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if (response.isSuccessful() && response.code() == 201) { // response != null
                        Log.e("hey", "response.isSuccessful()");
                        cOnResponse.onNoResponse();
                    }

                    if (!response.isSuccessful()) { // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(), POJOerror.class);
                        Log.e("hey", "errorCOde is: " + pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
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

    public class Me implements RequestInterface1 {
        Me(){
            Log.e("hey", "created Me object");
        }

        Call<POJOme> call1;
        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.me(headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        POJOme pojoMe = gson.fromJson(response.body().charStream(),POJOme.class);

                        cOnResponse.onPOJOResponse(pojoMe);
                    }

                    if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onNoResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
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

        Call<ResponseBody> call1;

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
            call1.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");

                    if(response.body() == null){
                        Log.e("hey", "response is null ");
                    }
                   /* if(response.body().toString() == ""){
                        Log.e("hey", "response is blank ");
                    } */

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        POJOerror pojoError = gson.fromJson(response.body().charStream(),POJOerror.class);

                        cOnResponse.onPOJOResponse(pojoError);
                    }

                    if(!response.isSuccessful()){ // response != null
                    //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onNoResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
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

                }
                @Override
                public void onFailure(Call<List<POJOsubject>> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

    public class GetTasksFromGroup implements RequestInterface1 {
        GetTasksFromGroup(){
            Log.e("hey", "created GetTasksFromGroup object");
        }

        Call<ResponseBody> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.getTasksFromGroup(vars.get("groupId").toString(), headerMap);
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

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
                        List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);

                     //   ArrayList<POJOgetTask> pojoError = gson.fromJson(response.body().charStream(),ArrayList.class);

                        cOnResponse.onPOJOResponse(castedList);
                    }

                    if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
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
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure();
                }
            });
            // TODO  requestType.get("key");
        }
    }

    public class GetTasksFromMe implements RequestInterface1 {
        GetTasksFromMe(){
            Log.e("hey", "created GetTasks object");
        }

        Call<ArrayList<POJOgetTask>> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.getTasksFromMe(headerMap);
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
    public class GetTask implements RequestInterface1 {
        GetTask(){
            Log.e("hey", "created GetTask object");
        }

       // Call<ResponseBody> call;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));

            call = aRequest.getTask(vars.get("groupId").toString(), vars.get("taskId").toString(), headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        POJOgetTaskDetailed pojo = gson.fromJson(response.body().charStream(),POJOgetTaskDetailed.class);

                        //   ArrayList<POJOgetTask> pojoError = gson.fromJson(response.body().charStream(),ArrayList.class);

                        cOnResponse.onPOJOResponse(pojo);
                    }

                    if(!response.isSuccessful()){
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
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

    public class GetUsers implements RequestInterface1 {
        //   public String name = "register";
        GetUsers(){
            Log.e("hey", "created CreateTask object");
        }

        Call<ResponseBody> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call1 = aRequest.getUsers(headerMap); //Integer.toString(groupID)
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

                    if(response.body() == null){
                        Log.e("hey", "response is null ");
                    }
                   /* if(response.body().toString() == ""){
                        Log.e("hey", "response is blank ");
                    } */

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        Type listType = new TypeToken<ArrayList<POJOgetUser>>(){}.getType();
                        List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);

                     //   POJOgetUser pojoError = gson.fromJson(response.body().charStream(),POJOerror.class);

                        cOnResponse.onPOJOResponse(castedList);
                    }

                    if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onNoResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e("hey", call.toString());
                    cOnResponse.onFailure();
                }
            });
        }
    }

    public class GetGroupsFromMe implements RequestInterface1 {
        //   public String name = "register";
        GetGroupsFromMe(){
            Log.e("hey", "created GetGroupsFromMe object");
        }

      //  Call<ResponseBody> call1;

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getGroupsFromMe(headerMap); //Integer.toString(groupID)
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");

                    if(response.body() == null){
                        Log.e("hey", "response is null ");
                    }
                   /* if(response.body().toString() == ""){
                        Log.e("hey", "response is blank ");
                    } */

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        Type listType = new TypeToken<ArrayList<POJOgroup>>(){}.getType();
                        List<POJOgroup> castedList = gson.fromJson(response.body().charStream(), listType);

                        //   POJOgetUser pojoError = gson.fromJson(response.body().charStream(),POJOerror.class);

                        cOnResponse.onPOJOResponse(castedList);
                    }

                    if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onNoResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e("hey", call.toString());
                    cOnResponse.onFailure();
                }
            });
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
