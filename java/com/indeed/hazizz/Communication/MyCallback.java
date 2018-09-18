package com.indeed.hazizz.Communication;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.TypeAdapter;
import com.indeed.hazizz.Communication.ResponseBodies;
import com.indeed.hazizz.Communication.User;

import java.io.IOException;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class MyCallback<ResponseBody> implements Callback<ResponseBody>{

    ResponseHandler rh;
    public MyCallback(ResponseHandler rh){
        this.rh = rh;
    }

    @Override
    public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {

     //   int errorCode = response.body().getErrorCode();
      //  response.body().a();
        User u = new User("", "", "");
        u.a();
      //  rh.checkErrorCode(errorCode);
        if (response.code() == 400) {
            // TODO You know what the response
        } /*else {
            errorCode = response.body().getErrorCode();
        } */
    }

    @Override
    public void onFailure(Call<ResponseBody> call, Throwable t) {
        int a = 0;
    }
}
