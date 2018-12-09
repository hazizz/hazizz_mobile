package com.indeed.hazizz.Communication.POJO.Response;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public interface CustomResponseHandler {
    void onResponse(HashMap<String, Object> response);
    void onPOJOResponse(Object response);
    void onFailure(Call<ResponseBody> call, Throwable t);
    void onErrorResponse(POJOerror error);
    void onEmptyResponse();
    void onSuccessfulResponse();
    void onNoConnection();

}