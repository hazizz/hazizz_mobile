package com.indeed.hazizz.Communication;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.HeaderMap;
import retrofit2.http.POST;

public interface SetupInterface {



    public Call<JSONObject> call(HashMap<String, String> headers, JSONObject registerBody);

  //  public void setup();

  //  public void call();

    public HashMap<String, String> makeHeader();

    public Call<JSONObject> call(JSONObject requestJson);


  /*  @POST("register/")
    Call<JSONObject> register(
            @HeaderMap Map<String, String> headers,
            @Body JSONObject registerBody

    );

    @POST("auth/")
    Call<JSONObject> auth(
           // @HeaderMap Map<String, String> headers,
            @Body JSONObject authBody
    ); */

}
