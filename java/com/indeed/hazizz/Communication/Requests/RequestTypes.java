package com.indeed.hazizz.Communication.Requests;

import com.indeed.hazizz.Communication.POJO.Response.POJOcreateTask;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Communication.POJO.Response.POJOregister;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;

import org.json.JSONObject;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.http.Body;
import retrofit2.http.HeaderMap;
import retrofit2.http.*;

public interface RequestTypes{

    @POST("register")
    Call<ResponseBody> register(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object>  register
    );

    @POST("auth/")
    Call<ResponseBody> refreshToken(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object>  register
    );


    @GET("users/")
    Call<ResponseBody> getUsers(
            @HeaderMap Map<String, String> headers
    );

    @POST("auth/")
    Call<ResponseBody> login(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, String> registerBody
    );

    @GET("me/details")
    Call<ResponseBody> me(
            @HeaderMap Map<String, String> headers
    );

    // Groups
    @GET("groups/{id}")
    Call<ResponseBody> getGroup(
            @Path("id") String id,
            @HeaderMap Map<String, String> headers
    );

    // Groups
    @GET("groups")
    Call<ResponseBody> getGroups(
            @HeaderMap Map<String, String> headers
    );

    @POST("groups/{id}/tasks")
    Call<ResponseBody> createTask(
            @Path("id") String id,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> taskBody
    );

    @PATCH("groups/{groupId}/tasks/{taskId}")
    Call<ResponseBody> updateTask(
            @Path("groupId") String groupId,
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> taskBody
    );

    @DELETE("groups/{groupId}/tasks/{taskId}")
    Call<ResponseBody> deleteTask(
            @Path("groupId") String groupId,
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers
    );

    @GET("subjects/{groupId}")  // /groups/{id}/subjects
    Call<ResponseBody> getSubjects(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers

    );

    @GET("groups/{id}/tasks")
    Call<ResponseBody> getTasksFromGroup(
            @Path("id") String id,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/tasks")
    Call<ResponseBody> getTasksFromMe(
            @HeaderMap Map<String, String> headers
    );

    @GET("groups/{groupId}/tasks/{taskId}")
    Call<ResponseBody> getTask(
            @Path("groupId") String groupId,
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers
    );

    @POST("groups/{id}/tasks")
    Call<ResponseBody> createTask(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/groups")
    Call<ResponseBody> getGroupsFromMe(
            @HeaderMap Map<String, String> headers
    );

    @POST("subjects/{groupId}")
    Call<ResponseBody> createSubject(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @POST("groups")
    Call<ResponseBody> createGroup(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );


    @POST("groups/{groupId}/invited")
    Call<ResponseBody> inviteUserToGroup(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @GET("me/joingroup/{groupId}")
    Call<ResponseBody> joinGroup(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("groups/{groupId}/users")
    Call<ResponseBody> getGroupMembers(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/leavegroup/{groupId}")
    Call<ResponseBody> leaveGroup(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("users/{userId}/picture")
    Call<ResponseBody> getUserProfilePic(
            @Path("userId") String userId,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/picture")
    Call<ResponseBody> getMyProfilePic(
            @HeaderMap Map<String, String> headers
    );

    @POST("feedbacks")
    Call<ResponseBody> feedback(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @POST("me/picture")
    Call<ResponseBody> setMyProfilePic(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @GET("comments/{commentId}")
    Call<ResponseBody> getCommentSection(
            @Path("commentId") String commentId,
            @HeaderMap Map<String, String> headers
    );

    @POST("comments/{commentId}")
    Call<ResponseBody> addComment(
            @Path("commentId") String commentId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @GET("announcements/{groupId}")
    Call<ResponseBody> getAnnouncements(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/announcements")
    Call<ResponseBody> getMyAnnouncements(
            @HeaderMap Map<String, String> headers
    );

    @POST("announcements/{groupId}")
    Call<ResponseBody> createAnnouncements(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> taskBody
    );

}
