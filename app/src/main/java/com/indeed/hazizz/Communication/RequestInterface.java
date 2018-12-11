package com.indeed.hazizz.Communication;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.google.gson.Gson;
import com.indeed.hazizz.Activities.AuthActivity;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJORefreshToken;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.ErrorHandler;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.SharedPrefs;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public interface RequestInterface {

     void setupCall();


     default void call(Activity act, Request request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
          call.enqueue(buildCallback(act, request, call, cOnResponse, gson));
     }

     default void callAgain(Activity act, Request request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
         // setupCall();
          call.clone().enqueue(buildCallback(act, request, call, cOnResponse, gson));
          Log.e("hey", "CALL AGAIN");
     }

     default Callback<ResponseBody> buildCallback(Activity act, Request request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
          Callback<ResponseBody> callback = new Callback<ResponseBody>() {
               @Override
               public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.e("hey", "gotResponse");
                    Log.e("hey", response.raw().toString());
                  //  boolean callAgain = false;

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

                         if(pojoError.getErrorCode() == 0) {
                              if(SharedPrefs.TokenManager.tokenInvalidated(act)){
                                   Intent i = new Intent(act, AuthActivity.class);

                                   act.startActivity(i);
                              }
                         }

                         else if(pojoError.getErrorCode() == 18 || pojoError.getErrorCode() == 17){
                              Manager.ThreadManager.freezeThread();
                              MiddleMan.addToCallAgain(request);
                            //  Log.e("hey", "the refresh token is: " + SharedPrefs.TokenManager.getRefreshToken(act));
                            //  Log.e("hey", "the access token is: " + SharedPrefs.TokenManager.getToken(act));
                              HashMap<String, Object> body = new HashMap<>();
                              body.put("username", SharedPrefs.getString(act.getBaseContext(), "userInfo", "username"));
                              body.put("refreshToken", SharedPrefs.TokenManager.getRefreshToken(act.getBaseContext()));

                              Log.e("hey", "the username is: " + body.get("username"));
                              Log.e("hey", "the refreshToken is: " + body.get("refreshToken"));

                             // HashMap<String, Object> vars = new HashMap<>();
                             // vars.put("requestAgain", request);

                          //    MiddleMan.newRequest(act, "refreshToken", body, null, vars);
                              Request r = new Request(act, "refreshToken", body, null, null);
                              r.requestType.setupCall();
                              r.requestType.makeCall();

                             /*  if(TokenManager.getRefreshToken(act).equals("used")){

                              }else{
                                   MiddleMan.cancelAllRequest();
                                   Log.e("hey", "refresh toke is fine");
                                   TokenManager.setUseTokenToRefresh(act);
                                   callAgain = true;
                              } */

                         }else {
                              cOnResponse.onErrorResponse(pojoError);
                         }
                    }
                    /*if(callAgain){
                         MiddleMan.callAgain(request);
                    }else{ */
                    MiddleMan.gotRequestResponse(request);
                   // }

                    //   else{cOnResponse.onEmptyResponse();}
               }
               @Override
               public void onFailure(Call<ResponseBody> call, Throwable t) {
                    cOnResponse.onFailure(call, t);
               }
          };
          return callback;
     }
     void makeCall();

     void makeCallAgain();

     void callIsSuccessful(Response<ResponseBody> response);

}

