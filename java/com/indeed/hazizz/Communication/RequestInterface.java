package com.indeed.hazizz.Communication;

import android.app.Activity;
import android.util.Log;

import com.google.gson.Gson;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.ErrorHandler;
import com.indeed.hazizz.TokenManager;
import com.indeed.hazizz.Transactor;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public interface RequestInterface {

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
                         callIsSuccessful(response);
                    }

                    else if(!response.isSuccessful()){ // response != null
                         POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                         Log.e("hey", "errorCOde is: " + pojoError.getErrorCode());
                         Log.e("hey", "errorMessage is: " + pojoError.getMessage());
                         if(pojoError.getErrorCode() == 1) {
                              ErrorHandler.unExpectedResponseDialog(act);
                         }


                         else if(pojoError.getErrorCode() == 18 || pojoError.getErrorCode() == 17){
                             Log.e("hey", "the refresh token is: " + TokenManager.getRefreshToken(act));
                             Log.e("hey", "the use token is: " + TokenManager.getUseToken(act));
                             Log.e("hey", "the access token is: " + TokenManager.getToken(act));
                              if(TokenManager.getRefreshToken(act).equals("used")){
                                   MiddleMan.cancelAllRequest();
                                   Log.e("hey", "aut activity opened");
                                   Transactor.AuthActivity(act);
                              }else{
                                   MiddleMan.cancelAllRequest();
                                   Log.e("hey", "refresh toke is fine");
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
