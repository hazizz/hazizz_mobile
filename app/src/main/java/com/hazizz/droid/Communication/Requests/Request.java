package com.hazizz.droid.Communication.Requests;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJOAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.CommentSectionPOJOs.POJOComment;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJORefreshToken;
import com.hazizz.droid.Communication.POJO.Response.POJOauth;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOgetUser;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOme;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.POJO.Response.PojoPicSmall;
import com.hazizz.droid.Communication.POJO.Response.PojoPublicUserData;
import com.hazizz.droid.Communication.POJO.Response.PojoToken;
import com.hazizz.droid.Communication.POJO.Response.PojoType;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.hazizz.droid.Communication.RequestInterface;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Manager;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.EnumMap;
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
    private final String THERA_URL = "https://hazizz.duckdns.org:9000/thera-server/";
    public RequestInterface requestType;
    private HashMap<String, Object> body;
    private Retrofit retrofit;
    private Retrofit thera_retrofit;

    Call<ResponseBody> call;
    RequestTypes aRequest;
    RequestTypes tRequest;

    public CustomResponseHandler cOnResponse;
    Context context;
    Activity act;

    private EnumMap<Strings.Path, Object> vars;
    
    Request thisRequest = this;

    private OkHttpClient okHttpClient;

    public Request(Activity act, String reqType, HashMap<String, Object> body, CustomResponseHandler cOnResponse, EnumMap<Strings.Path, Object> vars) {
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

        thera_retrofit = new Retrofit.Builder()
                .baseUrl(THERA_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                .build();

        findRequestType(reqType);
        aRequest = retrofit.create(RequestTypes.class);
        tRequest = thera_retrofit.create(RequestTypes.class);
    }

    public void cancelRequest(){
        okHttpClient.dispatcher().cancelAll();
        this.call.cancel();
    }

    public Request(Context context, String reqType, HashMap<String, Object> body, CustomResponseHandler cOnResponse, EnumMap<Strings.Path, Object> vars) {
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

        thera_retrofit = new Retrofit.Builder()
                .baseUrl(THERA_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                .build();

        findRequestType(reqType);
        aRequest = retrofit.create(RequestTypes.class);
        tRequest = thera_retrofit.create(RequestTypes.class);
    }

    public Request(Context context, RequestInterface reqType) {
        this.context = context;

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

        thera_retrofit = new Retrofit.Builder()
                .baseUrl(THERA_URL)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                .build();

        aRequest = retrofit.create(RequestTypes.class);
        tRequest = thera_retrofit.create(RequestTypes.class);

        requestType = reqType;
    }

    public RequestInterface getRequestType(){
        return requestType;
    }

    //called int the constructor


    private void findRequestType(String reqType) {}
    /*
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
            case "elevationToken":
                requestType = new ElevationToken();
                break;

            case "me":
                requestType = new Me();
                break;

            case "changePassword":
                requestType = new ChangePassword();
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
            case "deleteAT":
                requestType = new DeleteAT();
                break;
            case "editAT":
                requestType = new EditAT();
                break;
            case "createAT":
                requestType = new CreateAT();
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

            case "getUsers":
                requestType = new GetUsers();
                break;
            case "getTaskByGroup":
                requestType = new GetTaskByGroup();
                break;
            case "getTaskBySubject":
                requestType = new GetTaskBySubject();
                break;
            case "getTaskBy":
                requestType = new GetTaskBy();
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
            case "joinGroupByPassword":
                requestType = new JoinGroupByPassword();
                break;
            case "getGroupMembers":
                requestType = new GetGroupMembers();
                break;
            case "getGroupMemberPermisions":
                requestType = new GetGroupMemberPermisions();
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
            case "getTaskCommentsByGroup":
                requestType = new GetTaskCommentsByGroup();
                break;
            case "getTaskCommentsBySubject":
                requestType = new GetTaskCommentsBySubject();
                break;
            case "addTaskComment":
                requestType = new AddTaskComment();
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
            case "editAnnouncement":
                requestType = new EditAnnouncement();
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
            case "getTaskTypes":
                requestType = new GetTaskTypes();
                break;
            case "setDisplayName":
                requestType = new SetDisplayName();
                break;
            case "getPublicUserDetail":
                requestType = new GetPublicUserDetail();
                break;


            case "thSchools":
                requestType = new ThSchools();
                break;


            default:
                Log.e("hey", "DEFAULT!!!");
                break;
        }

    }

    */

    public class Login implements RequestInterface {
        String b_username, b_password;
        Login(String b_username, String b_password) {
            Log.e("hey", "created Login object");

            this.b_username = b_username;
            this.b_password = b_password;
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<>();
            headerMap.put("Content-Type", "application/json");
            HashMap<String, String> b = new HashMap<>();
            b.put("username", b_username);
            b.put("password", b_password);
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
        Register(String b_username, String b_password, String b_emailAddress) {
            Log.e("hey", "created");
            body.put("username", b_username);
            body.put("password", b_password);
            body.put("emailAddress", b_emailAddress);
            body.put("consent", true);
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
            public void onPOJOResponse(Object response) {
                POJORefreshToken pojoRefreshToken = (POJORefreshToken)response;
                SharedPrefs.TokenManager.setRefreshToken(act.getBaseContext(), pojoRefreshToken.getRefresh());
                SharedPrefs.TokenManager.setToken(act.getBaseContext(), pojoRefreshToken.getToken());
                Manager.ThreadManager.unfreezeThread();
                MiddleMan.callAgain();
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                if(error.getErrorCode() == 21){
                    MiddleMan.cancelAllRequest();
                    Transactor.AuthActivity(act);
                }
            }
        };

        RefreshToken() {
            Log.e("hey", "created RefreshToken");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");

            HashMap<String, Object> body = new HashMap<>();
            body.put("username", SharedPrefs.getString(act.getBaseContext(), "userInfo", "username"));
            body.put("refreshToken", SharedPrefs.TokenManager.getRefreshToken(act.getBaseContext()));

            call = aRequest.refreshToken(headerMap, body);
        }
        @Override
        public void makeCall() { call(act,  thisRequest, call, cOnResponse, gson); }
        @Override
        public void makeCallAgain() { callAgain(act,  thisRequest, call, customResponseHandler, gson); }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            POJORefreshToken pojo = gson.fromJson(response.body().charStream(), POJORefreshToken.class);
            customResponseHandler.onPOJOResponse(pojo);
        }
    }



    public class ElevationToken implements RequestInterface {
        ElevationToken(String b_hashedOldPassword) {
            Log.e("hey", "created ElevationToken object");
            body.put("password", b_hashedOldPassword);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");

            call = aRequest.elevationToken(headerMap, body);
        }
        @Override
        public void makeCall() {
            callSpec(act,  thisRequest, call, cOnResponse, gson);
        }
        @Override
        public void makeCallAgain() {
            callAgainSpec(act,  thisRequest, call, cOnResponse, gson);
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            PojoToken pojoToken = gson.fromJson(response.body().charStream(), PojoToken.class);
            cOnResponse.onPOJOResponse(pojoToken);
        }
    }


  /*  public Call<ResponseBody> getCall(){
        return call;
    } */



    public class ChangePassword implements RequestInterface {
        ChangePassword(String hashedNewPassword, String elevationToken) {
            Log.e("hey", "created Me object");
            body.put("password", hashedNewPassword);
            body.put("token", elevationToken);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.changePassword(headerMap, body);
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
        private int p_groupId;
        GetGroup(int p_groupId) {
            Log.e("hey", "created GetGroup object");
            this.p_groupId = p_groupId;
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
            call = aRequest.getGroup(Integer.toString(p_groupId), headerMap);
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

   /* public class CreateTask implements RequestInterface {
        private int p_groupId;
        CreateTask(int p_groupId) {
            Log.e("hey", "created TaskEditor object");
            this.p_groupId = p_groupId;
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
            call = aRequest.createTask(Integer.toString(p_groupId), headerMap, body); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    } */

    public class CreateAT implements RequestInterface {
        private Strings.Path p_whereName, p_byName;
        private int p_byId;
        CreateAT(Strings.Path p_whereName, Strings.Path p_byName, int p_byId,
                 int b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
            Log.e("hey", "created CreateAT object");
            this.p_whereName = p_whereName;
            this.p_byName = p_byName;
            this.p_byId = p_byId;

            body.put("taskType", b_taskType);
            body.put("taskTitle", b_taskTitle);
            body.put("description", b_description);
            body.put("dueDate", b_dueDate);

        }

        CreateAT(Strings.Path p_whereName, Strings.Path p_byName, int p_byId,
                 String b_announcementTitle, String b_description) {
            Log.e("hey", "created CreateAT object");
            this.p_whereName = p_whereName;
            this.p_byName = p_byName;
            this.p_byId = p_byId;

            body.put("announcementTitle", b_announcementTitle);
            body.put("description", b_description);

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
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.createAT(p_whereName.toString(), p_byName.toString(),
                    Integer.toString(p_byId), headerMap, body);

        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class EditAT implements RequestInterface {
        private Strings.Path p_whereName, p_byName;
        private int p_byId, p_whereId;
        EditAT(Strings.Path p_whereName, Strings.Path p_byName, int p_byId, int p_whereId,
               String b_taskType, String b_taskTitle, String b_description, String b_dueDate) {
            Log.e("hey", "created EditAT object");
            this.p_whereName = p_whereName;
            this.p_byName = p_byName;
            this.p_byId = p_byId;
            this.p_whereId = p_whereId;

            body.put("taskType", b_taskType);
            body.put("taskTitle", b_taskTitle);
            body.put("description", b_description);
            body.put("dueDate", b_dueDate);

        }
        EditAT(Strings.Path p_whereName, Strings.Path p_byName, int p_byId, int p_whereId,
               String b_announcementTitle, String b_description){
            Log.e("hey", "created EditAT object");
            this.p_whereName = p_whereName;
            this.p_byName = p_byName;
            this.p_byId = p_byId;
            this.p_whereId = p_whereId;

            body.put("announcementTitle", b_announcementTitle);
            body.put("description", b_description);
        }

        @Override
        public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }@Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.editAT(p_whereName.toString(), p_byName.toString(),
                    Integer.toString(p_byId), Integer.toString(p_whereId), headerMap, body);
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

  /*  public class EditTask implements RequestInterface {
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
            call = aRequest.editTask(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.TASKID).toString(), headerMap, body); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    } */

  /*  public class DeleteTask implements RequestInterface {
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
            call = aRequest.deleteTask(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.TASKID).toString(), headerMap); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    } */

    public class DeleteAT implements RequestInterface {
        String whereName, whereId, byName, byId;
        DeleteAT(Strings.Rank whereName, Strings.Rank whereId, Strings.Rank byName, Strings.Rank byId) {
            Log.e("hey", "created DeleteAT object");
            this.whereName = whereName.toString();
            this.whereId = whereId.toString();
            this.byName = byName.toString();
            this.byId = byId.toString();

        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

            call = aRequest.DeleteAT(whereName, byName, byId, whereId, headerMap);
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
            call = aRequest.deleteAnnouncement(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.ANNOUNCEMENTID).toString(), headerMap); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }

    public class GetSubjects implements RequestInterface {
        String p_groupId;
        GetSubjects(int p_groupId) {
            Log.e("hey", "created GetSubjects object");
            this.p_groupId = Integer.toString(p_groupId);
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
            call = aRequest.getSubjects(p_groupId, headerMap); // vars.get(id").toString()
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Type listType = new TypeToken<ArrayList<POJOsubject>>() {
            }.getType();
            ArrayList<POJOsubject> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        }
    }

    public class GetTaskTypes implements RequestInterface {
        GetTaskTypes() {
            Log.e("hey", "created GetTaskTypes object");
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
            call = aRequest.getTaskTypes(headerMap); // vars.get(id").toString()
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Type listType = new TypeToken<ArrayList<PojoType>>() {}.getType();
            ArrayList<PojoType> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        }
    }

    public class GetTasksFromGroup implements RequestInterface {
        String p_groupId;
        GetTasksFromGroup(int p_groupId) {
            Log.e("hey", "created GetTasksFromGroup object");
            this.p_groupId = Integer.toString(p_groupId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getTasksFromGroup(p_groupId, headerMap);
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
        public void call(Context act, Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
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
        public void callIsSuccessful(Response<ResponseBody> response) { }
    }

    public class GetATBy implements RequestInterface {
        private String p_whereName, p_byName;
        private String p_byId, p_whereId;
        GetATBy(Strings.Path p_whereName, Strings.Path p_byName, int p_byId, int p_whereId) {
            Log.e("hey", "created GetATBy object");
            this.p_whereName = p_whereName.toString();
            this.p_byName = p_byName.toString();
            this.p_byId = Integer.toString(p_byId);
            this.p_whereId = Integer.toString(p_whereId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

            call = aRequest.getATBy(p_whereName, p_byName, p_byId, p_whereId, headerMap);
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

/*
    public class GetTaskBySubject implements RequestInterface {
        GetTaskBySubject() {
            Log.e("hey", "created GetTaskBySubject object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getTaskBySubject(vars.get(Strings.Path.SUBJECTID).toString(), vars.get(Strings.Path.TASKID).toString(), headerMap);
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
    } */

 /*   public class GetTaskByGroup implements RequestInterface {
        GetTaskByGroup() {
            Log.e("hey", "created GetTaskBySubject object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getTaskByGroup(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.TASKID).toString(), headerMap);
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
    } */



    public class GetUsers implements RequestInterface {
        GetUsers() {
            Log.e("hey", "created TaskEditor object");
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
        String p_groupId, b_subjectName;
        CreateSubject(int p_groupId, String b_subjectName) {
            Log.e("hey", "created CreateSubject object");
            this.p_groupId = Integer.toString(p_groupId);
            this.b_subjectName = b_subjectName;
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));

            body.put("name", b_subjectName);
            call = aRequest.createSubject(p_groupId, headerMap, body);
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
        CreateGroup(String b_groupName, String b_groupType) {
            Log.e("hey", "created CreateGroup object");
            body.put("groupName", b_groupName);
            body.put("type", b_groupType);
        }
        CreateGroup(String b_groupName, String b_groupType, String b_password) {
            Log.e("hey", "created CreateGroup object");
            body.put("groupName", b_groupName);
            body.put("password", b_password);
            body.put("type", b_groupType);
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

    public class SetDisplayName implements RequestInterface {
        SetDisplayName(String b_displayName) {
            Log.e("hey", "created setDisplayName object");
            body.put("displayName", b_displayName);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));

            call = aRequest.setDisplayName(headerMap, body);
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
        inviteUserToGroup() {
            Log.e("hey", "created inviteUserToGroup object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.inviteUserToGroup(vars.get(Strings.Path.GROUPID).toString(), headerMap, body);
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
        private String groupId;
        JoinGroup(int groupId) {
            Log.e("hey", "created JoinGroup object");
            this.groupId = Integer.toString(groupId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.joinGroup(groupId, headerMap);
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

    public class JoinGroupByPassword implements RequestInterface {
        private String p_groupId, p_password;
        JoinGroupByPassword(int p_groupId, String p_password) {
            Log.e("hey", "created JoinGroupByPassword object");
            this.p_groupId = Integer.toString(p_groupId);
            this.p_password = p_password;
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.joinGroupByPassword(p_groupId, p_password, headerMap);
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
        private String p_groupId;
        GetGroupMembers(int p_groupId) {
            Log.e("hey", "created getGroupMembers object");
            this.p_groupId = Integer.toString(p_groupId);
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
            call = aRequest.getGroupMembers(p_groupId, headerMap);
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            Type listType = new TypeToken<ArrayList<POJOuser>>(){}.getType();
            List<POJOuser> castedList = gson.fromJson(response.body().charStream(), listType);
            cOnResponse.onPOJOResponse(castedList);
        }
    }
    public class GetGroupMemberPermisions implements RequestInterface {
        private String p_groupId;
        GetGroupMemberPermisions(int p_groupId) {
            Log.e("hey", "created GetGroupMemberPermisions object");
            this.p_groupId = Integer.toString(p_groupId);
        }
        @Override public void makeCall() {
            call(act,  thisRequest, call, cOnResponse, gson);
        }
        @Override
        public void makeCallAgain() {
            callAgain(act,  thisRequest, call, cOnResponse, gson);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getGroupMemberPermissions(p_groupId, headerMap);
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            PojoPermisionUsers pojo = gson.fromJson(response.body().charStream(), PojoPermisionUsers.class);
            cOnResponse.onPOJOResponse(pojo);
        }
    }

    public class LeaveGroup implements RequestInterface {
        private String p_groupId;
        LeaveGroup(int p_groupId) {
            Log.e("hey", "created LeaveGroup object");
            this.p_groupId = Integer.toString(p_groupId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");
            call = aRequest.getGroupMembers(p_groupId, headerMap);
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
        private String p_userId;
        GetUserProfilePic(int p_userId) {
            Log.e("hey", "created LeaveGroup object");
            this.p_userId = Integer.toString(p_userId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getUserProfilePic(p_userId, headerMap);
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
        Feedback(String b_platform, String b_version, String b_message, Object b_data) {
            Log.e("hey", "created Feedback object");
            body.put("platform", b_platform);
            body.put("version", b_version);
            body.put("message", b_message);
            body.put("data", b_data);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");


            call = aRequest.feedback(headerMap, body);
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
        SetMyProfilePic(String data) {
            Log.e("hey", "created GetMyProfilePic object");
            String finalString = data.replaceAll("\\s","");
            body.put("data", finalString);
            body.put("type", "ppfull");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");

            call = aRequest.setMyProfilePic(headerMap, body);
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
        String p_whereName,p_whereId, p_byName, p_byId;
        GetCommentSection(Strings.Rank whereName, int whereId, Strings.Rank byName, int byId) {
            Log.e("hey", "created GetMyProfilePic object");
            this.p_whereName = whereName.toString();
            this.p_whereId = Integer.toString(whereId);
            this.p_byName = byName.toString();
            this.p_byId = Integer.toString(byId);
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));

            call = aRequest.getCommentSection(p_whereName,p_byName, p_byId, p_whereId, headerMap);
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
            Type listType = new TypeToken<ArrayList<POJOComment>>(){}.getType();
            List<POJOComment> castedList = gson.fromJson(response.body().charStream(), listType);

            cOnResponse.onPOJOResponse(castedList);
        }
    }

  /*  public class GetTaskCommentsByGroup implements RequestInterface {
        GetTaskCommentsByGroup() {
            Log.e("hey", "created GetTaskComments object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getTaskCommentsByGroup(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.TASKID).toString(), headerMap); //
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
            Type listType = new TypeToken<ArrayList<POJOComment>>(){}.getType();
            List<POJOComment> castedList = gson.fromJson(response.body().charStream(), listType);

            cOnResponse.onPOJOResponse(castedList);
        }
    } */
/*
    public class GetTaskCommentsBySubject implements RequestInterface {
        GetTaskCommentsBySubject() {
            Log.e("hey", "created GetTaskCommentsBySubject object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getTaskCommentsBySubject(vars.get(Strings.Path.SUBJECTID).toString(), vars.get(Strings.Path.TASKID).toString(), headerMap); //
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
            // POJOCommentSection pojo = gson.fromJson(response.body().charStream(), POJOCommentSection.class);
            Type listType = new TypeToken<ArrayList<POJOComment>>(){}.getType();
            List<POJOComment> castedList = gson.fromJson(response.body().charStream(), listType);

            cOnResponse.onPOJOResponse(castedList);
        }
    } */

  /*  public class AddTaskComment implements RequestInterface {
        Strings.Rank p_groupId,
        AddTaskComment() {
            Log.e("hey", "created AddTaskComment object");
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");
            call = aRequest.addTaskComment(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.TASKID).toString(), body, headerMap); //
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
    } */

    public class AddComment implements RequestInterface {
        String p_whereName, p_whereId, p_byName, p_byId;
        AddComment(String content) {
            Log.e("hey", "created AddComment object");
            body.put("content", content);
        }

        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            headerMap.put("Content-Type", "application/json");

            call = aRequest.addComment(p_whereName, p_byName, p_byId, p_whereId, headerMap, body);
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
        String groupId;
        GetAnnouncementsFromGroup(int groupId) {
            Log.e("hey", "created GetAnnouncements object");
            this.groupId = Integer.toString(groupId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getAnnouncementsFromGroup(vars.get(Strings.Path.GROUPID).toString(), headerMap);
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
/*
    public class GetAnnouncement implements RequestInterface {
        GetAnnouncement() {
            Log.e("hey", "created GetAnnouncement object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getAnnouncement(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.ANNOUNCEMENTID).toString(), headerMap);

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
    */
/*
    public class CreateAnnouncement implements RequestInterface {
        CreateAnnouncement() {
            Log.e("hey", "created CreateAnnouncement object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Content-Type", "application/json");
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.createAnnouncement(vars.get(Strings.Path.GROUPID).toString(), headerMap, body);
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
*/
/*
    public class EditAnnouncement implements RequestInterface {
        EditAnnouncement(){
            Log.e("hey", "created EditAnnouncement object");
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
            call = aRequest.editAnnouncement(vars.get(Strings.Path.GROUPID).toString(), vars.get(Strings.Path.ANNOUNCEMENTID).toString(), headerMap, body); //Integer.toString(groupID)
        }
        @Override
        public void callIsSuccessful(Response<ResponseBody> response) {
            cOnResponse.onSuccessfulResponse();
        }
    }
    */

    public class GetGroupMembersProfilePic implements RequestInterface {
        String groupId;
        GetGroupMembersProfilePic(int groupId) {
            Log.e("hey", "created GetAnnouncements object");
            this.groupId = Integer.toString(groupId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getGroupMembersProfilePic(groupId ,headerMap);
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


    public class GetPublicUserDetail implements RequestInterface {
        String userId;
        GetPublicUserDetail(int userId) {
            Log.e("hey", "created getPublicUserDetail object");
            this.userId = Integer.toString(userId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getPublicUserDetail(userId,headerMap);
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
            PojoPublicUserData castedObject = gson.fromJson(response.body().charStream(), PojoPublicUserData.class);
            cOnResponse.onPOJOResponse(castedObject);
        }
    }

    public class GetGroupMembersProfilePicSync implements RequestInterface {
        String groupId;
        GetGroupMembersProfilePicSync(int groupId) {
            Log.e("hey", "created GetGroupMembersProfilePicSync object");
            this.groupId = Integer.toString(groupId);
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));
            call = aRequest.getGroupMembersProfilePic(groupId ,headerMap);
        }
        @Override
        public void makeCall() {
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
        public void call(Context act, Request r, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){

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




    // Théra time

    public class ThSchools implements RequestInterface {
        ThSchools() {
            Log.e("hey", "created ThSchools object");
        }
        public void setupCall() {
            HashMap<String, String> headerMap = new HashMap<String, String>();
            headerMap.put("Authorization", "Bearer " + SharedPrefs.TokenManager.getToken(act.getBaseContext()));//SharedPrefs.TokenManager.getToken(act.getBaseContext()));

            call = tRequest.getSchools(headerMap);
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
            Type listType = new TypeToken<HashMap<String, String>>(){}.getType();
            HashMap<String, String> castedMap = gson.fromJson(response.body().charStream(), listType);

            cOnResponse.onPOJOResponse(castedMap);
        }
    }

}

//TODO java.lang.IllegalStateException: Already executed. at retrofit2.OkHttpCall.enqueue(OkHttpCall.java:84)
