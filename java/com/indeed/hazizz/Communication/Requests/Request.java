package com.indeed.hazizz.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.indeed.hazizz.Communication.POJO.Response.CommentSectionPOJOs.POJOCommentSection;
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
import com.indeed.hazizz.TokenManager;

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
    public RequestInterface requestType;
    private HashMap<String, Object> body;
    private Retrofit retrofit;

    Call<ResponseBody> call;
    RequestTypes aRequest;

    public CustomResponseHandler cOnResponse;
    Context context;
    Activity act;

    private HashMap<String, String> vars;
    
    Request thisRequest = this;

    private OkHttpClient okHttpClient;


    public Request(Activity act, String reqType, HashMap<String, Object> body, CustomResponseHandler cOnResponse, HashMap<String, String> vars) {
        this.cOnResponse = cOnResponse;
        this.body = body;
        this.context = context;
        this.vars = vars;
        this.act = act;

        //.excludeFieldsWithModifiers(Modifier.FINAL, Modifier.TRANSIENT, Modifier.STATIC)
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

        findRequestType(reqType);
        aRequest = retrofit.create(RequestTypes.class);
    }

    public void cancelRequest(){
        okHttpClient.dispatcher().cancelAll();
    }

    public Request(Context context, String reqType, HashMap<String, Object> body, CustomResponseHandler cOnResponse, HashMap<String, String> vars) {
        this.cOnResponse = cOnResponse;
        this.body = body;
        this.context = context;
        this.vars = vars;

        //.excludeFieldsWithModifiers(Modifier.FINAL, Modifier.TRANSIENT, Modifier.STATIC)
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

        findRequestType(reqType);
        aRequest = retrofit.create(RequestTypes.class);
    }


    public void findRequestType(String reqType) {
        switch (reqType) {
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
            case "setMyProfilePic":
                requestType = new SetMyProfilePic();
                break;
            case "feedback":
                requestType = new Feedback();
                break;
            case "getCommentSection":
                requestType = new GetCommentSection();
                break;
            case "addComment":
                requestType = new AddComment();
                break;


        }
    }


    public class Login implements RequestInterface {
        //   public String name = "register";
        Login() {
            Log.e("hey", "created Login object");
        }

        //
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");

            HashMap<String, String> b = new HashMap<>();
            b.put("username", body.get("username").toString());
            b.put("password", body.get("password").toString());
            call = aRequest.login(headerMap, b);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            POJOauth pojoAuth = gson.fromJson(response.body().charStream(), POJOauth.class);
            cOnResponse.onPOJOResponse(pojoAuth);
        }
    }

    public class Register implements RequestInterface {
        Register() {
            Log.e("hey", "created");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            call = aRequest.register(headerMap, body);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }

    }

    public class Me implements RequestInterface {
        Me() {
            Log.e("hey", "created Me object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.me(headerMap);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            POJOme pojoMe = gson.fromJson(response.body().charStream(), POJOme.class);
            cOnResponse.onPOJOResponse(pojoMe);
        }

    }

    public class GetGroup implements RequestInterface {
        //   public String name = "register";
        GetGroup() {
            Log.e("hey", "created GetGroup object");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getGroup(vars.get("groupId").toString(), headerMap);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            POJOgroup pojoGroup = gson.fromJson(response.body().charStream(), POJOgroup.class);
            cOnResponse.onPOJOResponse(pojoGroup);
        }
    }

    public class GetGroups implements RequestInterface {
        GetGroups() {
            Log.e("hey", "created GetGroups object");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }
        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getGroups(headerMap);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Log.e("hey", "response.isSuccessful()");
            Type listType = new TypeToken<ArrayList<POJOgroup>>() {
            }.getType();
            ArrayList<POJOgroup> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        }


    }

    public class CreateTask implements RequestInterface {
        //   public String name = "register";
        CreateTask() {
            Log.e("hey", "created CreateTask object");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.createTask(vars.get("id").toString(), headerMap, body); //Integer.toString(groupID)
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class GetSubjects implements RequestInterface {
        GetSubjects() {
            Log.e("hey", "created GetSubjects object");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getSubjects(vars.get("groupId").toString(), headerMap); // vars.get("id").toString()
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Log.e("hey", "response.isSuccessful()");

            Type listType = new TypeToken<ArrayList<POJOsubject>>() {
            }.getType();
            ArrayList<POJOsubject> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        }

    }

    public class GetTasksFromGroup implements RequestInterface {
        GetTasksFromGroup() {
            Log.e("hey", "created GetTasksFromGroup object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getTasksFromGroup(vars.get("groupId").toString(), headerMap);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Log.e("hey", "response.isSuccessful()");

            Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
            List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
            Log.e("hey", "size of response list: " + castedList.size());
        }

    }

    public class GetTasksFromMe implements RequestInterface {
        GetTasksFromMe() {
            Log.e("hey", "created GetTasks object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getTasksFromMe(headerMap);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Type listType = new TypeToken<ArrayList<POJOgetTask>>(){}.getType();
            List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
            Log.e("hey", "on POJOResponse called wow");
            Log.e("hey", "size of response list: " + castedList.size());
        }

    }

    public class GetTasksFromMeSync implements RequestInterface {
        GetTasksFromMeSync() {
            Log.e("hey", "created GetTasksFromMeSync object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(context));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getTasksFromMe(headerMap);
        }

        @Override
        public void makeCall() {
          //  call(act,  thisRequest, call, cOnResponse, gson);
            try {
                Response<ResponseBody> response = call.execute();
             //   response.body();
                try {
                    Type listType = new TypeToken<ArrayList<POJOgetTask>>() {
                    }.getType();
                    List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
                    cOnResponse.onPOJOResponse(castedList);
                }catch (Exception e){
                    POJOerror error = gson.fromJson(response.errorBody().charStream(), POJOerror.class);
                    cOnResponse.onErrorResponse(error);
                }

            } catch (IOException e) {
                e.printStackTrace();
                Log.e("hey", "exception");
            }
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        public void call(Context act,  Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
            try {
                Response<ResponseBody> response = call.execute();
                response.body();
                Type listType = new TypeToken<ArrayList<POJOgetTask>>() {
                }.getType();
                List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
                cOnResponse.onPOJOResponse(castedList);

            } catch (IOException e) {
                e.printStackTrace();
                Log.e("hey", "exception");
            }
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {

        }


     /*   public void call() {
            try {
                Response<ResponseBody> response = call.execute();
                response.body();
                Type listType = new TypeToken<ArrayList<POJOgetTask>>() {
                }.getType();
                List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);
                cOnResponse.onPOJOResponse(castedList);

            } catch (IOException e) {
                e.printStackTrace();
            }
        } */
    }

    public class GetTask implements RequestInterface {
        GetTask() {
            Log.e("hey", "created GetTask object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));

            call = aRequest.getTask(vars.get("groupId").toString(), vars.get("taskId").toString(), headerMap);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            POJOgetTaskDetailed pojo = gson.fromJson(response.body().charStream(), POJOgetTaskDetailed.class);
            cOnResponse.onPOJOResponse(pojo);
        }
    }


    public class GetUsers implements RequestInterface {
        //   public String name = "register";
        GetUsers() {
            Log.e("hey", "created CreateTask object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getUsers(headerMap); //Integer.toString(groupID)
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Type listType = new TypeToken<ArrayList<POJOgetUser>>() {
            }.getType();
            List<POJOgetTask> castedList = gson.fromJson(response.body().charStream(), listType);

            cOnResponse.onPOJOResponse(castedList);
        }


    }

    public class GetGroupsFromMe implements RequestInterface {
        GetGroupsFromMe() {
            Log.e("hey", "created GetGroupsFromMe object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getGroupsFromMe(headerMap); //Integer.toString(groupID)
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Type listType = new TypeToken<ArrayList<POJOgroup>>() {
            }.getType();
            List<POJOgroup> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        }

    }

    public class CreateSubject implements RequestInterface {
        CreateSubject() {
            Log.e("hey", "created CreateSubject object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));

            call = aRequest.createSubject(vars.get("groupId").toString(), headerMap, body);
        }
        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }

    }

    public class CreateGroup implements RequestInterface {
        CreateGroup() {
            Log.e("hey", "created CreateGroup object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));

            call = aRequest.createGroup(headerMap, body);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();

        }

    }

    public class inviteUserToGroup implements RequestInterface {
        //   public String name = "register";
        inviteUserToGroup() {
            Log.e("hey", "created inviteUserToGroup object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));

            call = aRequest.inviteUserToGroup(vars.get("groupId").toString(), headerMap, body);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }

    }

    public class JoinGroup implements RequestInterface {
        JoinGroup() {
            Log.e("hey", "created JoinGroup object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.joinGroup(vars.get("groupId").toString(), headerMap);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class GetGroupMembers implements RequestInterface {
        GetGroupMembers() {
            Log.e("hey", "created getGroupMembers object");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getGroupMembers(vars.get("groupId").toString(), headerMap);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Type listType = new TypeToken<ArrayList<POJOuser>>() {
            }.getType();
            List<POJOuser> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        }

    }


    public class LeaveGroup implements RequestInterface {
        LeaveGroup() {
            Log.e("hey", "created LeaveGroup object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");
            call = aRequest.getGroupMembers(vars.get("groupId").toString(), headerMap);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }

    }

    public class GetUserProfilePic implements RequestInterface {
        GetUserProfilePic() {
            Log.e("hey", "created LeaveGroup object");
        }


        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getUserProfilePic(vars.get("userId").toString(), headerMap);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            PojoPicSmall pojoPicSmall = gson.fromJson(response.body().charStream(), PojoPicSmall.class);
            cOnResponse.onPOJOResponse(pojoPicSmall);
        }
    }

    public class GetMyProfilePic implements RequestInterface {
        GetMyProfilePic() {
            Log.e("hey", "created GetMyProfilePic object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getMyProfilePic(headerMap);
            Log.e("hey", "setup call on getMyProfilePic");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            PojoPicSmall pojoPicSmall = gson.fromJson(response.body().charStream(), PojoPicSmall.class);
            cOnResponse.onPOJOResponse(pojoPicSmall);
        }
    }


    public class Feedback implements RequestInterface {
        Feedback() {
            Log.e("hey", "created Feedback object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");
            HashMap<String, Object> b = new HashMap<>();
            b.put("platform", body.get("platform"));
            b.put("version", body.get("version"));
            b.put("message", body.get("message"));
            b.put("data", body.get("data"));

            call = aRequest.feedback(headerMap, b);
            Log.e("hey", "setup call on Feedback");
        }
        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }
        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class SetMyProfilePic implements RequestInterface {
        SetMyProfilePic() {
            Log.e("hey", "created GetMyProfilePic object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");

            Log.e("hey" , "data is: " + body.get("data"));

            String finalString = body.get("data").toString().replaceAll("\\s","");
            HashMap<String, Object> body2 = new HashMap<>();
            body2.put("data", finalString);
          //  body2.put("data", "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABQODxIPDRQSEBIXFRQYHjIhHhwcHj0sLiQySUBMS0dARkVQWnNiUFVtVkVGZIhlbXd7gYKBTmCNl4x9lnN+gXz/2wBDARUXFx4aHjshITt8U0ZTfHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHz/wAARCAAyADIDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDs6KKa54xQA6mtIqnBYZ9O9QuhYHa7Rk9SuM0JGsYO0Yz1PUn8aAJd/oPzpw5FRZqVfuigBaKKKACuQP2i4utTkl1We1gtpscbmGCxA4B9q6+uOF9HZy6yrBHlkmHlpIm5Ww5znt3rObsdWGi5XstdPzJTZXMPm/a9cmhCTiFW+YgkqGBPPHB+g9aYLa7hhle/1ie28ubyeAzgnAIPB7io4Lm1vdPaLUr145WuvOY7CxYbQOwwP6Y6VNPr7G3mktHMM8lzu2lQTsCAc5GOoFRdbnWqdS/Lb8P+AS+GLq4n+1CeZ5Nuwje2cZ3Z/lXSxf6sVynhbh7v6J/7NXVQ/wCqFaQ1icWJXLVkkSUUUVZzhVK406xYPI1nbs7HJYxKSTnr0q7UcwZo8KMkmgabRmf2fY/8+dv/AN+l/wAKb/Z9j/z52/8A36X/AAq55Ev939RSi2kI/hH1NFg5n3K0UEFvu8iGOLd12KFz+VaMAxCufTNRraKD8zE/pVgDAwKBBRRRQAUUUUAFFFFABRRRQAUUUUAf/9k=");
            body2.put("type", "ppfull");

            if(body.get("data").equals(body2.get("data"))){
                Log.e("hey", "its the same dude");
            }else{
                Log.e("hey", "its not the same dude");
            }

            Log.e("hey" , "data2 is: " + body2.get("data"));

            call = aRequest.setMyProfilePic(headerMap, body2);
            Log.e("hey", "setup call on setMyProfilePic");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class GetCommentSection implements RequestInterface {
        GetCommentSection() {
            Log.e("hey", "created GetMyProfilePic object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            call = aRequest.getCommentSection(vars.get("commentId"), headerMap); //
            Log.e("hey", "setup call on GetCommentSection");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            POJOCommentSection pojo = gson.fromJson(response.body().charStream(), POJOCommentSection.class);
            cOnResponse.onPOJOResponse(pojo);
        }
    }

    public class AddComment implements RequestInterface {
        AddComment() {
            Log.e("hey", "created AddComment object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + TokenManager.getUseToken(act.getBaseContext()));//TokenManager.getUseToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");

            call = aRequest.addComment(vars.get("commentId") ,headerMap, body);
            Log.e("hey", "setup call on AddComment");
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }
}



//TODO java.lang.IllegalStateException: Already executed. at retrofit2.OkHttpCall.enqueue(OkHttpCall.java:84)
