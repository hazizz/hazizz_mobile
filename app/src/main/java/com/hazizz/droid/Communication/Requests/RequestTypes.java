package com.hazizz.droid.Communication.Requests;

import com.google.gson.JsonElement;

import java.util.HashMap;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.GET;
import retrofit2.http.HeaderMap;
import retrofit2.http.PATCH;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

public interface RequestTypes{

    @POST("register")
    Call<ResponseBody> register(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> register
    );

    @POST("auth/")
    Call<ResponseBody> refreshToken(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> register
    );

    @POST("auth/")
    Call<ResponseBody> login(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> registerBody
    );

    @POST("elevation/")
    Call<ResponseBody> elevationToken(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> newPasswordBody
    );


    @GET("users/")
    Call<ResponseBody> getUsers(
            @HeaderMap Map<String, String> headers
    );


    @PATCH("me/password")
    Call<ResponseBody> changePassword(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> changePasswordBody
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
    Call<ResponseBody> editTask(
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

    @DELETE("announcements/{groupId}/{announcementId}")
    Call<ResponseBody> deleteAnnouncement(
            @Path("groupId") String groupId,
            @Path("announcementId") String taskId,
            @HeaderMap Map<String, String> headers
    );

    @GET("subjects/{groupId}")  // /groups/{id}/subjects
    Call<ResponseBody> getSubjects(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers

    );

    @GET("tasks/types")  // /groups/{id}/subjects
    Call<ResponseBody> getTaskTypes(
            @HeaderMap Map<String, String> headers
    );



    @GET("me/tasks/groups/{groupId}")
    Call<ResponseBody> getTasksFromGroup(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/tasks")
    Call<ResponseBody> getTasksFromMe(
            @HeaderMap Map<String, String> headers
    );



    @PATCH("{whereName}/{whereId}")
    Call<ResponseBody> editAT(
            @Path("whereName") String whereName,
            @Path("whereId") String whereId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @POST("{whereName}/{byName}/{byId}")
    Call<ResponseBody> createAT(
            @Path("whereName") String whereName,
            @Path("byName") String byName,
            @Path("byId") String byId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @GET("tasks/groups/{groupId}/{taskId}")
    Call<ResponseBody> getTaskByGroup(
            @Path("groupId") String groupId,
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers

    );

    @GET("{whereName}/{byName}/{byId}/{whereId}")
    Call<ResponseBody> getATBy(
            @Path("whereName") String whereName,
            @Path("byName") String byName,
            @Path("byId") String byId,
            @Path("whereId") String whereId,
            @HeaderMap Map<String, String> headers
    );


    @GET("{whereName}/{whereId}")
    Call<ResponseBody> getAT(
            @Path("whereName") String whereName,
            @Path("whereId") String whereId,
            @HeaderMap Map<String, String> headers
    );

    @GET("tasks/me")
    Call<ResponseBody> getMyTasks(
            @HeaderMap Map<String, String> headers
    );

    @GET("tasks/me")
    Call<ResponseBody> getMyTaskDetailed(
            @HeaderMap Map<String, String> headers
    );

    @POST("tasks/me")
    Call<ResponseBody> createMyTask(
            @Body HashMap<String, Object> body,
            @HeaderMap Map<String, String> headers
    );
    @PATCH("tasks/me/{taskId}")
    Call<ResponseBody> updateMyTask(
            @Path("taskId") String taskId,
            @Body HashMap<String, Object> body,
            @HeaderMap Map<String, String> headers
    );
    @GET("tasks/me/{taskId}")
    Call<ResponseBody> deleteMyTask(
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers
    );

    @GET("tasks/subjects/{subjectId}/{taskId}")
    Call<ResponseBody> getTaskBySubject(
            @Path("subjectId") String subjectId,
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers
    );


    @POST("groups/{id}/tasks")
    Call<ResponseBody> TaskEditor(
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


    @DELETE("subjects/group/{groupId}/{subjectId}")
    Call<ResponseBody> deleteSubject(
            @Path("groupId") String groupId,
            @Path("subjectId") String subjectId,
            @HeaderMap Map<String, String> headers
    );

    @PATCH("subjects/group/{groupId}/{subjectId}")
    Call<ResponseBody> editSubject(
            @Path("groupId") String groupId,
            @Path("subjectId") String subjectId,
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

    @GET("me/joingroup/{groupId}/{grouppass}")
    Call<ResponseBody> joinGroupByPassword(
            @Path("groupId") String groupId,
            @Path("grouppass") String grouppass,
            @HeaderMap Map<String, String> headers
    );

    @GET("groups/{groupId}/users")
    Call<ResponseBody> getGroupMembers(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("groups/{groupId}/permissions")
    Call<ResponseBody> getGroupMemberPermissions(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("groups/{groupId}/permissions/{userId}")
    Call<ResponseBody> getUserPermissionInGroup(
            @Path("groupId") String groupId,
            @Path("userId") String userId,
            @HeaderMap Map<String, String> headers
    );


    @GET("me/leavegroup/{groupId}")
    Call<ResponseBody> leaveGroup(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("users/{userId}/picture/{size}")
    Call<ResponseBody> getUserProfilePic(
            @Path("userId") String userId,
            @Path("size") String size,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/picture/{size}")
    Call<ResponseBody> getMyProfilePic(
            @Path("size") String size,
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

    @GET("{whereName}/{whereId}/comments")
    Call<ResponseBody> getCommentSection(
            @Path("whereName") String whereName,
            @Path("whereId") String whereId,
            @HeaderMap Map<String, String> headers
    );

    @GET("tasks/groups/{groupId}/{taskId}/comments")
    Call<ResponseBody> getTaskCommentsByGroup(
            @Path("groupId") String groupId,
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers
    );

    @GET("tasks/subjects/{subjectId}/{taskId}/comments")
    Call<ResponseBody> getTaskCommentsBySubject(
            @Path("subjectId") String groupId,
            @Path("taskId") String taskId,
            @HeaderMap Map<String, String> headers
    );



    @POST("tasks/groups/{groupId}/{taskId}/comments")
    Call<ResponseBody> addTaskComment(
            @Path("groupId") String groupId,
            @Path("taskId") String taskId,
            @Body HashMap<String, Object> body,
            @HeaderMap Map<String, String> headers
    );

    @POST("{whereName}/{whereId}/comments")
    Call<ResponseBody> addComment(
            @Path("whereName") String whereName,
            @Path("whereId") String whereId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @DELETE("{whereName}/{whereId}")
    Call<ResponseBody> deleteAT(
            @Path("whereName") String whereName,
            @Path("whereId") String whereId,
            @HeaderMap Map<String, String> headers
    );


    @DELETE("{whereName}/{whereId}/comments/{commentId}")
    Call<ResponseBody> deleteATComment(
            @Path("whereName") String whereName,
            @Path("whereId") String whereId,
            @Path("commentId") String commentId,
            @HeaderMap Map<String, String> headers
    );

 /*   @POST("comments/{commentId}")
    Call<ResponseBody> addComment(
            @Path("commentId") String commentId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    ); */

    @GET("me/announcements/groups/{groupId}")  // announcements/{groupId}
    Call<ResponseBody> getAnnouncementsFromGroup(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @GET("me/announcements")
    Call<ResponseBody> getMyAnnouncements(
            @HeaderMap Map<String, String> headers
    );

    @POST("announcements/groups/{groupId}")
    Call<ResponseBody> createAnnouncement(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> taskBody
    );

    @PATCH("announcements/{groupId}/{announcementId}")
    Call<ResponseBody> editAnnouncement(
            @Path("groupId") String groupId,
            @Path("announcementId") String announcementId,
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> taskBody
    );


    @GET("groups/{groupId}/users/picture")
    Call<ResponseBody> getGroupMembersProfilePic(
            @Path("groupId") String groupId,
            @HeaderMap Map<String, String> headers
    );

    @POST("me/displayname")
    Call<ResponseBody> setDisplayName(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> body
    );

    @GET("announcements/groups/{groupId}/{announcementId}")
    Call<ResponseBody> getAnnouncement(
            @Path("groupId") String groupId,
            @Path("announcementId") String announcementId,
            @HeaderMap Map<String, String> headers
    );


    @GET("users/{userId}")
    Call<ResponseBody> getPublicUserDetail(
            @Path("userId") String userId,
            @HeaderMap Map<String, String> headers
    );



    @GET("information/motd")
    Call<ResponseBody> messageOfTheDay();

    @GET("admin/log")
    Call<ResponseBody> getLog(
            @Query("size") String logSize,
            @HeaderMap Map<String, String> headers
    );



    @GET("kreta/schools")
    Call<ResponseBody> th_getSchools(
            @HeaderMap Map<String, String> headers
    );

    @POST("kreta/sessions")
    Call<ResponseBody> th_createSession(
            @HeaderMap Map<String, String> headers,
            @Body Map<String, Object> body
    );

    @GET("kreta/sessions")
    Call<ResponseBody> th_returnSessions(
            @HeaderMap Map<String, String> headers
    );




}
