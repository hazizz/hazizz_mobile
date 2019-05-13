package com.hazizz.droid.communication.requestTypes;

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

public interface TheraRequestTypes {


    @GET("kreta/schools")
    Call<ResponseBody> th_getSchools(
            @HeaderMap Map<String, String> headers
    );

    @POST("kreta/sessions")
    Call<ResponseBody> th_createSession(
            @HeaderMap Map<String, String> headers,
            @Body Map<String, Object> body
    );


    @DELETE("kreta/sessions/{sessionId}")
    Call<ResponseBody> th_removeSession(
            @Path("sessionId") String sessionId,
            @HeaderMap Map<String, String> headers
    );

    @POST("kreta/sessions/{sessionId}/auth")
    Call<ResponseBody> th_authenticateSession(
            @Path("sessionId") String sessionId,
            @HeaderMap Map<String, String> headers,
            @Body Map<String, Object> body
    );

    @GET("kreta/sessions")
    Call<ResponseBody> th_returnSessions(
            @HeaderMap Map<String, String> headers
    );


    @GET("kreta/sessions/{sessionId}/grades")
    Call<ResponseBody> th_returnGrades(
            @Path("sessionId") String sessionId,
            @HeaderMap Map<String, String> headers
    );


    @GET("kreta/sessions/{sessionId}/schedule")
    Call<ResponseBody> th_returnSchedules(
            @Path("sessionId") String sessionId,
            @Query("weekNumber") String weekNumber,
            @Query("year") String year,
            @HeaderMap Map<String, String> headers
    );
}
