package com.indeed.hazizz.Communication.Requests;

//import com.indeed.hazizz.Communication.POJO.Requests.Register;
import com.indeed.hazizz.Communication.POJO.Requests.RequestInterface;
import com.indeed.hazizz.Communication.POJO.Response.Error;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOme;
import com.indeed.hazizz.Communication.POJO.Response.ResponseInterface;
import com.indeed.hazizz.Communication.SetupInterface;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.HeaderMap;
import retrofit2.http.*;

public interface RequestTypes{

    @POST("register")
    Call<HashMap<String, Object>> register(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object>  register
    );

    @GET("users/")
    Call<HashMap<String, Object>> getUsers(
            @HeaderMap Map<String, String> headers,
            @Body JSONObject registerBody
    );

    @POST("auth/")
    Call<HashMap<String, Object>> login(
            @HeaderMap Map<String, String> headers,
            @Body HashMap<String, Object> registerBody
    );

    @GET("me/details")
    Call<POJOme> me(
            @HeaderMap Map<String, String> headers
    );

    // Groups

    @GET("groups/{id}")
    Call<POJOgroup> getGroup(
            @Path("id") String id,
            @HeaderMap Map<String, String> headers
    );
}
