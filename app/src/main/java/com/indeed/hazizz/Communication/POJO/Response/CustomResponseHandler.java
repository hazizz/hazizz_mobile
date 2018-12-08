package com.indeed.hazizz.Communication.POJO.Response;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public interface CustomResponseHandler {



    public void onResponse(HashMap<String, Object> response);
    public void onPOJOResponse(Object response);
    public void onFailure(Call<ResponseBody> call, Throwable t);
    public void onErrorResponse(POJOerror error);
    public void onEmptyResponse();
    public void onSuccessfulResponse();
    public void onNoConnection();

}