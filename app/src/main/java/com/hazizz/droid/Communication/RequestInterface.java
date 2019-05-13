package com.hazizz.droid.communication;


import retrofit2.Callback;
import retrofit2.Response;

import okhttp3.ResponseBody;

public interface RequestInterface {

     void setupCall();

     void call();

     void callAgain();

     Callback<ResponseBody> buildCallback();

     void processResponse(Response<ResponseBody> response);

     void makeCall();

     void makeCallAgain();

     void callIsSuccessful(Response<ResponseBody> response);

     void cancelRequest();
}

