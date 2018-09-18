package com.indeed.hazizz.Communication;


import org.json.JSONObject;

import java.util.Map;

import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.HeaderMap;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;


public interface UserClientnotUsed {

    Call<User> createAccount(User user);
    String BASE_URL = "http://80.98.42.103:8080/";

    @POST("register")
    Call<ResponseBodies.Error> register(
            @Body RequestBodies.Register registerBody);


}
