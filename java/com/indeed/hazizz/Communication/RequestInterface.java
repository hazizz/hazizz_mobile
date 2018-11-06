package com.indeed.hazizz.Communication;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.TokenManager;
import com.indeed.hazizz.Transactor;

import org.json.JSONObject;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public interface RequestInterface {
    /* protected Context context;
     protected HashMap<String, Object> body;
     protected CustomResponseHandler cOnResponse;
     protected HashMap<String, String> vars; */
  //  boolean callAgain = true;



     public void setupCall();


     public default void call(Activity act, Request request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
          call.enqueue(buildCallback(act, request, call, cOnResponse, gson));
     }

     public default void callAgain(Activity act, Request request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
          call.clone().enqueue(buildCallback(act, request, call, cOnResponse, gson));
          Log.e("hey", "CALL AGAIN");
     }

     public default Callback<ResponseBody> buildCallback(Activity act, Request request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
          Callback<ResponseBody> callback = new Callback<ResponseBody>() {
               @Override
               public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());
                    boolean callAgain = false;

                    if(response.body() == null){
                         Log.e("hey", "response is null ");
                    }
                    if(response.isSuccessful()){ // response != null
                         Log.e("hey", "response.isSuccessful()");
                         // callAgain = false;
                         callIsSuccessful( response);
                    }

                    else if(!response.isSuccessful()){ // response != null
                         POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                         Log.e("hey", "errorCOde is: " + pojoError.getErrorCode());
                         if(pojoError.getErrorCode() == 17){
                              if(TokenManager.getRefreshToken(act).equals("")){
                                   Transactor.AuthActivity(act);
                              }else{
                                   TokenManager.setUseTokenToRefresh(act);
                                   callAgain = true;
                              }

                         }else {
                              cOnResponse.onErrorResponse(pojoError);
                         }
                    }

                    if(callAgain){
                         MiddleMan.callAgain(request);
                    }else{
                         MiddleMan.gotRequestResponse(request);
                    }

                    //   else{cOnResponse.onEmptyResponse();}
               }
               @Override
               public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
               }
          };

          return callback;
     }

     public void makeCall();

     public void makeCallAgain();

     public void callIsSuccessful(Response<ResponseBody> response);




}
