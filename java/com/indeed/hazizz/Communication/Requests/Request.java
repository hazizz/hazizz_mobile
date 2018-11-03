package com.indeed.hazizz.Communication.Requests;

import android.content.Context;
import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOauth;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgetUser;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.POJOuser;
import com.indeed.hazizz.Communication.POJO.Response.PojoPicSmall;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.indeed.hazizz.Communication.RequestInterface;
import com.indeed.hazizz.SharedPrefs;

import java.io.IOException;
import java.lang.reflect.Constructor;
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
    public RequestInterface requestType;
    private HashMap<String, Object> body;
    private Retrofit retrofit;

    Call<ResponseBody>  call;
    RequestTypes aRequest;

    public CustomResponseHandler cOnResponse;
    Context context;

    private HashMap<String, String> vars;

    private boolean reacted = false;

    public void setReacted(boolean r){reacted = r;}
    public boolean getReacted(){return reacted;}



    public Request(Context context, String reqType, HashMap<String, Object>  body, CustomResponseHandler cOnResponse, HashMap<String, String> vars){
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

            case "getUserProfilePic":
                requestType = new GetUserProfilePic();
                break;
            case "getMyProfilePic":
                requestType = new GetMyProfilePic();
                break;

        }
    }


    public class Login implements RequestInterface {
        //   public String name = "register";
        Login(){
            Log.e("hey", "created Login object");
        }

      //  @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");

            HashMap<String, String> b = new HashMap<>();
            b.put("username", body.get("username").toString());
            b.put("password", body.get("password").toString());
            call = aRequest.login(headerMap, b);
        }

      //  public HashMap<String, Object>  getResponse() { return response1; }

       // @Override
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

    public class Register implements RequestInterface {
        Register(){
            Log.e("hey", "created");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            call = aRequest.register(headerMap, body);
        }

           

        
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

    public class Me implements RequestInterface {
        Me(){
            Log.e("hey", "created Me object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.me(headerMap);
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

    public class GetGroup implements RequestInterface {
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

    public class GetGroups implements RequestInterface {
        GetGroups(){
            Log.e("hey", "created GetGroups object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getGroups(headerMap);
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

    public class CreateTask implements RequestInterface {
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

    public class GetSubjects implements RequestInterface {
        GetSubjects(){
            Log.e("hey", "created Me object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getSubjects(vars.get("groupId").toString(), headerMap); // vars.get("id").toString()
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

    public class GetTasksFromGroup implements RequestInterface {
        GetTasksFromGroup(){
            Log.e("hey", "created GetTasksFromGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getTasksFromGroup(vars.get("groupId").toString(), headerMap);
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

    public class GetTasksFromMe implements RequestInterface {
        GetTasksFromMe(){
            Log.e("hey", "created GetTasks object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getTasksFromMe(headerMap);
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

    public class GetTasksFromMeSync implements RequestInterface {
        GetTasksFromMeSync(){
            Log.e("hey", "created GetTasksFromMeSync object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getTasksFromMe(headerMap);
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

    public class GetTask implements RequestInterface {
        GetTask(){
            Log.e("hey", "created GetTask object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));

            call = aRequest.getTask(vars.get("groupId").toString(), vars.get("taskId").toString(), headerMap);
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

    public class GetUsers implements RequestInterface {
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

    public class GetGroupsFromMe implements RequestInterface {
        GetGroupsFromMe(){
            Log.e("hey", "created GetGroupsFromMe object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getGroupsFromMe(headerMap); //Integer.toString(groupID)
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

    public class CreateSubject implements RequestInterface {
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

    public class CreateGroup implements RequestInterface {
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

    public class inviteUserToGroup implements RequestInterface {
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

    public class JoinGroup implements RequestInterface {
        JoinGroup(){
            Log.e("hey", "created JoinGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.joinGroup(vars.get("groupId").toString(), headerMap);
        }

           
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

    public class GetGroupMembers implements RequestInterface {
        GetGroupMembers(){
            Log.e("hey", "created getGroupMembers object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getGroupMembers(vars.get("groupId").toString(), headerMap);
        }

           
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


    public class LeaveGroup implements RequestInterface {
        LeaveGroup(){
            Log.e("hey", "created LeaveGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            headerMap.put("Content-Type", "application/json");
            call = aRequest.getGroupMembers(vars.get("groupId"), headerMap);
        }

           
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

    public class GetUserProfilePic implements RequestInterface {
        GetUserProfilePic(){
            Log.e("hey", "created LeaveGroup object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getUserProfilePic(vars.get("userId"), headerMap);
        }


        @Override
        public void makeCall() {
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {

                    if(response.isSuccessful()){ // response != null

                        PojoPicSmall pojoPicSmall = gson.fromJson(response.body().charStream(),PojoPicSmall.class);
                        cOnResponse.onPOJOResponse(pojoPicSmall);
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
    public class GetMyProfilePic implements RequestInterface {
        GetMyProfilePic(){
            Log.e("hey", "created GetMyProfilePic object");
        }

        @Override
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.getString(context, "token", "token"));//SharedPrefs.getString(context, "token", "token"));
            call = aRequest.getMyProfilePic(headerMap);
            Log.e("hey", "setup call on getMyProfilePic");
        }

        @Override
        public void makeCall() {
            Log.e("hey", "made call on getMyProfilePic");
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {

                    if(response.isSuccessful()){ // response != null
                        PojoPicSmall pojoPicSmall = gson.fromJson(response.body().charStream(),PojoPicSmall.class);
                        cOnResponse.onPOJOResponse(pojoPicSmall);

                    }
                    else if(!response.isSuccessful()){ // response != null
                        //    Log.e("hey", (String)response.body().toString());
                        POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                        Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                        cOnResponse.onErrorResponse(pojoError);
                    }
                    else{cOnResponse.onEmptyResponse();
                        Log.e("hey", "got empty response");
                    }
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


//TODO java.lang.IllegalStateException: Already executed. at retrofit2.OkHttpCall.enqueue(OkHttpCall.java:84)
