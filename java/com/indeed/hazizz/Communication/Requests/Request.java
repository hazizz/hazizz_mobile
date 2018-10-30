package com.indeed.hazizz.Communication.Requests;

import android.content.Context;
import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOauth;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgetUser;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.POJOuser;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.indeed.hazizz.Communication.RequestInterface1;
import com.indeed.hazizz.SharedPrefs;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class Request {

    private Gson gson = new Gson();
    private final String BASE_URL = "https://hazizz.duckdns.org:8081/";
    public RequestInterface1 requestType;
    private HashMap<String, Object> response1;
    private HashMap<String, Object> body;
    private Retrofit retrofit;

    Call<ResponseBody>  call;
    RequestTypes aRequest;

    public CustomResponseHandler cOnResponse;
    Context context;

    private HashMap<String, Object> vars;

    private boolean reacted = false;

    public void setReacted(boolean r){reacted = r;}
    public boolean getReacted(){return reacted;}



    public Request(Context context, String reqType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars){
        this.cOnResponse = cOnResponse;
        this.body = body;
        this.context = context;
        this.vars = vars;

        //.excludeFieldsWithModifiers(Modifier.FINAL, Modifier.TRANSIENT, Modifier.STATIC)
        Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();

        final OkHttpClient okHttpClient = new OkHttpClient.Builder()
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
            case "getGroups":
                requestType = new GetGroups();
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
            case "getTasksFromMeSync":
                requestType = new GetTasksFromMeSync();
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
            case "createSubject":
                requestType = new CreateSubject();
                break;
            case "createGroup":
                requestType = new CreateGroup();
                break;

            case "joinGroup":
                requestType = new JoinGroup();
                break;

            case "getGroupMembers":
                requestType = new GetGroupMembers();
                break;

            case "leaveGroup":
                requestType = new LeaveGroup();
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

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");
                        POJOauth pojoAuth = gson.fromJson(response.body().charStream(),POJOauth.class);
                        cOnResponse.onPOJOResponse(pojoAuth);
                    }

                    if(!response.isSuccessful()){ // response != null
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                }
            });
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

                    if (response.isSuccessful()) { // response != null
                        Log.e("hey", "response.isSuccessful()");
                        cOnResponse.onSuccessfulResponse();
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
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class Me implements RequestInterface1 {
        Me(){
            Log.e("hey", "created Me object");
        }

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
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetGroup implements RequestInterface1 {
        //   public String name = "register";
        GetGroup(){
            Log.e("hey", "created GetGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getGroup(vars.get("groupId").toString(), headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");
                        POJOgroup pojoGroup = gson.fromJson(response.body().charStream(),POJOgroup.class);
                        cOnResponse.onPOJOResponse(pojoGroup);
                    }
                    if(!response.isSuccessful()){ // response != null
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetGroups implements RequestInterface1 {
        GetGroups(){
            Log.e("hey", "created GetGroups object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getGroups(headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");
                        Type listType = new TypeToken<ArrayList<POJOgroup>>(){}.getType();
                        ArrayList<POJOgroup> castedList = gson.fromJson(response.body().charStream(), listType);
                        cOnResponse.onPOJOResponse(castedList);
                    }
                    if(!response.isSuccessful()){ // response != null
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class CreateTask implements RequestInterface1 {
        //   public String name = "register";
        CreateTask(){
            Log.e("hey", "created CreateTask object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.createTask(vars.get("id").toString(), headerMap, body); //Integer.toString(groupID)
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

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");
                        POJOerror pojoError = gson.fromJson(response.body().charStream(),POJOerror.class);
                        cOnResponse.onPOJOResponse(pojoError);
                    }

                    if(!response.isSuccessful()){ // response != null
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e("hey", call.toString());
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetSubjects implements RequestInterface1 {
        GetSubjects(){
            Log.e("hey", "created Me object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getSubjects(vars.get("groupId").toString(), headerMap); // vars.get("id").toString()
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() { // List<POJOsubject>
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        Type listType = new TypeToken<ArrayList<POJOsubject>>(){}.getType();
                        ArrayList<POJOsubject> castedList = gson.fromJson(response.body().charStream(), listType);
                        if(castedList == null || castedList.size() == 0){
                            cOnResponse.onEmptyResponse();
                        }else {
                            cOnResponse.onPOJOResponse(castedList);
                        }
                    }
                    if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetTasksFromGroup implements RequestInterface1 {
        GetTasksFromGroup(){
            Log.e("hey", "created GetTasksFromGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getTasksFromGroup(vars.get("groupId").toString(), headerMap);
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

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
                        List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
                        if(castedList == null || castedList.size() == 0){
                            cOnResponse.onEmptyResponse();
                        }else {
                            cOnResponse.onPOJOResponse(castedList);
                        }
                    }

                    if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetTasksFromMe implements RequestInterface1 {
        GetTasksFromMe(){
            Log.e("hey", "created GetTasks object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getTasksFromMe(headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() { // ArrayList<POJOegtTask>
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());

                    if(response.isSuccessful()){ // response != null response.isSuccessful()
                        Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
                        List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
                        if(castedList == null || castedList.size() == 0){
                            cOnResponse.onEmptyResponse();
                        }else {
                            cOnResponse.onPOJOResponse(castedList);
                        }
                    }
                    if(!response.isSuccessful()){ // response != null response.isSuccessful()
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetTasksFromMeSync implements RequestInterface1 {
        GetTasksFromMeSync(){
            Log.e("hey", "created GetTasksFromMeSync object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getTasksFromMe(headerMap);
        }
        public HashMap<String, Object>  getResponse() {
            return response1;
        }

        @Override
        public void makeCall() {
            try {
                Response<ResponseBody> response = call.execute();
                response.body();
                Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
                List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
                cOnResponse.onPOJOResponse(castedList);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public class GetTask implements RequestInterface1 {
        GetTask(){
            Log.e("hey", "created GetTask object");
        }

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
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetUsers implements RequestInterface1 {
        //   public String name = "register";
        GetUsers(){
            Log.e("hey", "created CreateTask object");
        }


        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getUsers(headerMap); //Integer.toString(groupID)
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

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        Type listType = new TypeToken<ArrayList<POJOgetUser>>(){}.getType();
                        List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);

                        cOnResponse.onPOJOResponse(castedList);
                    }

                    if(!response.isSuccessful()){ // response != null
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e("hey", call.toString());
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class GetGroupsFromMe implements RequestInterface1 {
        GetGroupsFromMe(){
            Log.e("hey", "created GetGroupsFromMe object");
        }

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

                    if(response.isSuccessful()){ // response != null
                        Log.e("hey", "response.isSuccessful()");

                        Type listType = new TypeToken<ArrayList<POJOgroup>>(){}.getType();
                        List<POJOgroup> castedList = gson.fromJson(response.body().charStream(), listType);

                        //   POJOgetUser pojoError = gson.fromJson(response.body().charStream(),POJOerror.class);
                        if(castedList == null || castedList.size() == 0){
                            cOnResponse.onEmptyResponse();
                        }else {
                            cOnResponse.onPOJOResponse(castedList);
                        }
                    }
                    else if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e("hey", call.toString());
                    cOnResponse.onFailure(call, t);
                }
            });
        }
    }

    public class CreateSubject implements RequestInterface1 {
        CreateSubject(){
            Log.e("hey", "created CreateSubject object");
        }
        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));

            call = aRequest.createSubject(vars.get("groupId").toString(), headerMap, body);
        }

        public HashMap<String, Object>  getResponse() { return response1; }
        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {

                    if(response.isSuccessful()){ // response != null
                        cOnResponse.onSuccessfulResponse();
                    }
                    else if(!response.isSuccessful()){ // response != null
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                    Log.e("hey", "Failure: " + call.toString());
                    t.printStackTrace();
                }
            });
        }
    }

    public class CreateGroup implements RequestInterface1 {
        CreateGroup(){
            Log.e("hey", "created CreateGroup object");
        }
        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));

            call = aRequest.createGroup(headerMap, body);
        }

        public HashMap<String, Object>  getResponse() { return response1; }
        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {

                    if(response.isSuccessful()){ // response != null
                        cOnResponse.onSuccessfulResponse();
                    }

                    else if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                    Log.e("hey", "Failure: " + call.toString());
                    t.printStackTrace();
                }
            });
        }
    }

    public class inviteUserToGroup implements RequestInterface1 {
        //   public String name = "register";
        inviteUserToGroup(){
            Log.e("hey", "created inviteUserToGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));

            call = aRequest.inviteUserToGroup(vars.get("groupId").toString(), headerMap, body);
        }

        public HashMap<String, Object>  getResponse() { return response1; }
        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {

                    if(response.isSuccessful()){ // response != null
                        cOnResponse.onSuccessfulResponse();
                    }

                    else if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                    Log.e("hey", "Failure: " + call.toString());
                    t.printStackTrace();
                }
            });
        }
    }

    public class JoinGroup implements RequestInterface1 {
        JoinGroup(){
            Log.e("hey", "created JoinGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.joinGroup(vars.get("groupId").toString(), headerMap);
        }

        public HashMap<String, Object>  getResponse() { return response1; }
        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    if(response.isSuccessful()){ // response != null
                        cOnResponse.onSuccessfulResponse();
                    }
                    else if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                    Log.e("hey", "Failure: " + call.toString());
                    t.printStackTrace();
                }
            });
        }
    }

    public class GetGroupMembers implements RequestInterface1 {
        GetGroupMembers(){
            Log.e("hey", "created getGroupMembers object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getGroupMembers(vars.get("groupId").toString(), headerMap);
        }

        public HashMap<String, Object>  getResponse() { return response1; }
        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    if(response.isSuccessful()){ // response != null

                        Type listType = new TypeToken<ArrayList<POJOuser>>(){}.getType();
                        List<POJOuser> castedList = gson.fromJson(response.body().charStream(), listType);
                        cOnResponse.onPOJOResponse(castedList);
                    }
                    else if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                    Log.e("hey", "Failure: " + call.toString());
                    t.printStackTrace();
                }
            });
        }
    }


    public class LeaveGroup implements RequestInterface1 {
        LeaveGroup(){
            Log.e("hey", "created LeaveGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            headerMap.put("Content-Type", "application/json");
            call = aRequest.getGroupMembers(vars.get("groupId").toString(), headerMap);
        }

        public HashMap<String, Object>  getResponse() { return response1; }
        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    if(response.isSuccessful()){ // response != null
                        cOnResponse.onSuccessfulResponse();
                    }
                    else if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();}
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
                    Log.e("hey", "Failure: " + call.toString());
                    t.printStackTrace();
                }
            });
        }
    }
}

// TODO java.lang.IllegalStateException: Already executed. at retrofit2.OkHttpCall.enqueue(OkHttpCall.java:84)
