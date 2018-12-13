package com.indeed.hazizz.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs.POJOAnnouncement;
import com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.indeed.hazizz.Communication.POJO.Response.CommentSectionPOJOs.POJOCommentSection;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;
import com.indeed.hazizz.Communication.POJO.Response.POJORefreshToken;
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
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.SharedPrefs;
import com.indeed.hazizz.Transactor;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
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

    private HashMap<String, Object> vars;
    
    Request thisRequest = this;

    private OkHttpClient okHttpClient;

    public Request(Activity act, String reqType, HashMap<String, Object> body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars) {
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

    public Request(Context context, String reqType, HashMap<String, Object> body, CustomResponseHandler cOnResponse, HashMap<String, Object> vars) {
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
            case "refreshToken":
                requestType = new RefreshToken();
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
            case "editTask":
                requestType = new EditTask();
                break;
            case "deleteTask":
                requestType = new DeleteTask();
                break;
            case "deleteAnnouncement":
                requestType = new DeleteAnnouncement();
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
            case "getAnnouncementsFromGroup":
                requestType = new GetAnnouncementsFromGroup();
                break;
            case "getMyAnnouncements":
                requestType = new GetMyAnnouncements();
                break;
            case "createAnnouncement":
                requestType = new CreateAnnouncement();
                break;
            case "getGroupMembersProfilePic":
                requestType = new GetGroupMembersProfilePic();
                break;
            case "getGroupMembersProfilePicSync":
                requestType = new GetGroupMembersProfilePicSync();
                break;
            case "getAnnouncement":
                requestType = new GetAnnouncement();
                break;
            case "messageOfTheDay":
                requestType = new MessageOfTheDay();
                break;

        }
    }
    public class Login implements RequestInterface {
        Login() {
            Log.e("hey", "created Login object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");

            HashMap<String, String> b = new HashMap<>();
            b.put("username", body.get("username").toString());
            b.put("password", body.get("password").toString());
            call = aRequest.login(headerMap, body);
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

    public class RefreshToken implements RequestInterface {
        CustomResponseHandler customResponseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) { }
            @Override
            public void onPOJOResponse(Object response) {
               // MiddleMan.cancelAllRequest();
                POJORefreshToken pojoRefreshToken = (POJORefreshToken)response;
                SharedPrefs.TokenManager.setRefreshToken(act.getBaseContext(), pojoRefreshToken.getRefresh());
                SharedPrefs.TokenManager.setToken(act.getBaseContext(), pojoRefreshToken.getToken());
                Manager.ThreadManager.unfreezeThread();
               // MiddleMan.callAgain((Request) vars.get("requestAgain"));
                MiddleMan.callAgain();


                Log.e("hey", "onPOJOResponse 123");
                //  POJORefreshToken asd = new POJORefreshToken();
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) { }
            @Override
            public void onErrorResponse(POJOerror error) {
                if(error.getErrorCode() == 21){
                    MiddleMan.cancelAllRequest();
                    Log.e("hey", "aut activity opened");
                    Transactor.AuthActivity(act);
                }
            }
            @Override
            public void onEmptyResponse() { }
            @Override
            public void onSuccessfulResponse() { }
            @Override
            public void onNoConnection() { }

            @Override
            public void getHeaders(Headers headers) {

            }
        };

        RefreshToken() {
            Log.e("hey", "created RefreshToken");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            call = aRequest.refreshToken(headerMap, body);
        }
        @Override
        public void makeCall() { call(act,  thisRequest, call, cOnResponse, gson);
           /* try {
                Response<ResponseBody> response = call.execute();
                try {
                    POJORefreshToken pojo = gson.fromJson(response.body().charStream(), POJORefreshToken.class);
                    cOnResponse.onPOJOResponse(pojo);
                }catch (Exception e){
                    POJOerror error = gson.fromJson(response.errorBody().charStream(), POJOerror.class);
                    cOnResponse.onErrorResponse(error);
                }
            } catch (IOException e) {
                e.printStackTrace();
                Log.e("hey", "exception");
            } */
        }
        @Override
        public void makeCallAgain() {
          //  setupCall();
            callAgain(act,  thisRequest, call, customResponseHandler, gson);
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            POJORefreshToken pojo = gson.fromJson(response.body().charStream(), POJORefreshToken.class);
            customResponseHandler.onPOJOResponse(pojo);
        }
    }

    public class Me implements RequestInterface {
        Me() {
            Log.e("hey", "created Me object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.createTask(vars.get("id").toString(), headerMap, body); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class EditTask implements RequestInterface {
        EditTask() {
            Log.e("hey", "created EditTask object");
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.editTask(vars.get("groupId").toString(), vars.get("taskId").toString(), headerMap, body); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class DeleteTask implements RequestInterface {
        DeleteTask() {
            Log.e("hey", "created UpdateTask object");
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.deleteTask(vars.get("groupId").toString(), vars.get("taskId").toString(), headerMap); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class DeleteAnnouncement implements RequestInterface {
        DeleteAnnouncement() { Log.e("hey", "created UpdateTask object"); }
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.deleteAnnouncement(vars.get("groupId").toString(), vars.get("announcementId").toString(), headerMap); //Integer.toString(groupID)
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
        }
    }

    public class GetTasksFromMeSync implements RequestInterface {
        GetTasksFromMeSync() {
            Log.e("hey", "created GetTasksFromMeSync object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(context));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getTasksFromMe(headerMap);
        }
        @Override
        public void makeCall() {
          //  call(act,  thisRequest, call, cOnResponse, gson);
            try {
                Response<ResponseBody> response = call.execute();
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
    }

    public class GetTask implements RequestInterface {
        GetTask() {
            Log.e("hey", "created GetTask object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
        GetUsers() {
            Log.e("hey", "created CreateTask object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getUsers(headerMap); //Integer.toString(groupID)
        }
        @Override
        public void makeCall() {
            call(act, thisRequest, call, cOnResponse, gson);
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));

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
            cOnResponse.getHeaders(response.headers());
        }
    }

    public class inviteUserToGroup implements RequestInterface {
        inviteUserToGroup() {
            Log.e("hey", "created inviteUserToGroup object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");

            Log.e("hey" , "data is: " + body.get("data"));
            String finalString = body.get("data").toString().replaceAll("\\s","");
            HashMap<String, Object> body2 = new HashMap<>();
            body2.put("data", finalString);
            body2.put("type", "ppfull");

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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getCommentSection(vars.get("commentId").toString(), headerMap); //
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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");

            call = aRequest.addComment(vars.get("commentId").toString() ,headerMap, body);
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

    public class GetAnnouncementsFromGroup implements RequestInterface {
        GetAnnouncementsFromGroup() {
            Log.e("hey", "created GetAnnouncements object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getAnnouncementsFromGroup(vars.get("groupId").toString(), headerMap);
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

            Type listType = new TypeToken<ArrayList<POJOAnnouncement>>(){}.getType();
            List<POJOAnnouncement> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
            Log.e("hey", "size of response list: " + castedList.size());
        }
    }

    public class GetMyAnnouncements implements RequestInterface {
        GetMyAnnouncements() {
            Log.e("hey", "created GetAnnouncements object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getMyAnnouncements(headerMap);
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
            Type listType = new TypeToken<ArrayList<POJOAnnouncement>>(){}.getType();
            List<POJOAnnouncement> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
            Log.e("hey", "size of response list: " + castedList.size());
        }
    }

    public class GetAnnouncement implements RequestInterface {
        GetAnnouncement() {
            Log.e("hey", "created GetAnnouncement object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getAnnouncement(vars.get("groupId").toString(), vars.get("announcementId").toString(), headerMap);
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
            POJODetailedAnnouncement pojo = gson.fromJson(response.body().charStream(), POJODetailedAnnouncement.class);
            cOnResponse.onPOJOResponse(pojo);
        }
    }

    public class CreateAnnouncement implements RequestInterface {
        CreateAnnouncement() {
            Log.e("hey", "created CreateAnnouncement object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.createAnnouncements(vars.get("groupId").toString(), headerMap, body);
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
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class GetGroupMembersProfilePic implements RequestInterface {
        GetGroupMembersProfilePic() {
            Log.e("hey", "created GetAnnouncements object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getGroupMembersProfilePic(vars.get("groupId").toString() ,headerMap);
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
            Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
            HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedMap);
            Log.e("hey", "size of response map: " + castedMap.size());
        }
    }

    public class GetGroupMembersProfilePicSync implements RequestInterface {
        GetGroupMembersProfilePicSync() {
            Log.e("hey", "created GetGroupMembersProfilePicSync object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getGroupMembersProfilePic(vars.get("groupId").toString() ,headerMap);
        }
        @Override
        public void makeCall() {
            //  call(act,  thisRequest, call, cOnResponse, gson);
            try {
                Response<ResponseBody> response = call.execute();
                Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
                HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);

                cOnResponse.onPOJOResponse(castedMap);
            } catch (IOException e) {
                e.printStackTrace();
                Log.e("hey", "exception");
            }
        }

        public HashMap<Integer, POJOMembersProfilePic> getGroupMembersProfilePic(){
            Response<ResponseBody> response = null;
            try {
                response = call.execute();
            } catch (IOException e) {
                e.printStackTrace();
            }
            Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
            HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
            return castedMap;
        }

        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }
        public void call(Context act,  Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){

        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) { }
    }

    public class MessageOfTheDay implements RequestInterface {
        MessageOfTheDay() {
            Log.e("hey", "created MessageOfTheDay object");
        }

        public void setupCall() {
            call = aRequest.messageOfTheDay();
        }

        @Override
        public void makeCall() {
            call(act, thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void makeCallAgain() {
            callAgain(act, thisRequest, call, cOnResponse, gson);
        }

        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
           /* Type listType = new TypeToken<HashMap<Integer, POJOMembersProfilePic>>(){}.getType();
            HashMap<Integer, POJOMembersProfilePic> castedMap = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedMap);
            Log.e("hey", "size of response map: " + castedMap.size());*/
            try {
                String r = response.body().string();
                cOnResponse.onPOJOResponse(r.substring(1, r.length() - 1));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

//TODO java.lang.IllegalStateException: Already executed. at retrofit2.OkHttpCall.enqueue(OkHttpCall.java:84)
