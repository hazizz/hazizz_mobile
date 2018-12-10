package com.indeed.hazizz.Communication.POJO.Response;

import java.util.HashMap;

import okhttp3.ResponseBody;
import okhttp3.Headers;
import retrofit2.Call;

public interface CustomResponseHandler {
    default void onResponse(HashMap<String, Object> response){};
    default void onPOJOResponse(Object response){};
    default void onFailure(Call<ResponseBody> call, Throwable t){};
    default void onErrorResponse(POJOerror error){};
    default void onEmptyResponse(){};
    default void onSuccessfulResponse(){};
    default void onNoConnection(){};
    default void getHeaders(Headers headers){};

}