package com.hazizz.droid.communication;


import retrofit2.Callback;
import retrofit2.Response;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.google.gson.Gson;
import com.hazizz.droid.activities.MainActivity;
import com.hazizz.droid.communication.requests.parent.AuthRequest;
import com.hazizz.droid.communication.requests.RequestType.Tokens.RefreshToken;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.R;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.manager.ThreadManager;
import com.hazizz.droid.other.ErrorHandler;
import com.hazizz.droid.other.SharedPrefs;

import okhttp3.ResponseBody;
import retrofit2.Call;

public interface RequestInterface2 {

    void setupCall();

    default void call(Activity act, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        call.enqueue(buildCallback(act, request, call, cOnResponse, gson));
    }

    default void independentCall(Context context, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                if(response.body() == null){
                    Log.e("hey", "response is null ");
                }
                if(response.isSuccessful()){ // response != null
                    Log.e("hey", "response.isSuccessful()");
                    callIsSuccessful(response);
                }

                else if(!response.isSuccessful()){ // response != null
                    PojoError PojoError = gson.fromJson(response.errorBody().charStream(),PojoError.class);
                    Log.e("hey", "errorCOde is: " + PojoError.getErrorCode());
                    Log.e("hey", "errorMessage is: " + PojoError.getMessage());

                    ThreadManager threadManager = ThreadManager.getInstance();


                    if(PojoError.getErrorCode() == 18 || PojoError.getErrorCode() == 17) {
                        MiddleMan.addToCallAgain(request);
                        if(!threadManager.isFreezed()) {
                            threadManager.freezeThread();

                            AuthRequest r = new RefreshToken(context);
                            r.setupCall();
                            r.makeCall();

                            Answers.getInstance().logCustom(new CustomEvent("Token")
                                    .putCustomAttribute("token", "refresh the token")
                            );
                        }
                        // too many requests
                    }else if(PojoError.getErrorCode() == 19){
                        if(!threadManager.isDelayed()) {
                            threadManager.startDelay();

                            MiddleMan.cancelAndSaveAllRequests();
                            MiddleMan.addToCallAgain(request);
                        }else {
                            MiddleMan.addToCallAgain(request);
                        }
                        Answers.getInstance().logCustom(new CustomEvent("Request")
                                .putCustomAttribute("request", "to many requests")
                        );
                    }else {
                        if(cOnResponse != null){
                            cOnResponse.onErrorResponse(PojoError);
                        }
                    }
                    String errorMessage =  PojoError.getMessage().substring(0, Math.min(PojoError.getMessage().length(), 100));;
                    Answers.getInstance().logCustom(new CustomEvent("Request error")
                            .putCustomAttribute("error code: ", PojoError.getErrorCode())
                            .putCustomAttribute("error message: ", errorMessage)
                            .putCustomAttribute("time: ", PojoError.getTime())
                    );
                }
                MiddleMan.gotRequestResponse(request);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                if(cOnResponse != null) {
                    cOnResponse.onFailure(call, t);
                }
            }
        });
    }

    default void callAgain(Activity act, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        call.clone().enqueue(buildCallback(act, request, call, cOnResponse, gson));
        Log.e("hey", "CALL AGAIN");
    }

    default Callback<ResponseBody> buildCallback(Activity act, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        Callback<ResponseBody> callback = new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                Log.e("hey", "gotResponse");
                Log.e("hey", response.raw().toString());

                if(response.body() == null){
                    Log.e("hey", "response is null ");
                }
                if(response.isSuccessful()){ // response != null
                    Log.e("hey", "response.isSuccessful()");
                    callIsSuccessful(response);
                }

                else if(!response.isSuccessful()){ // response != null

                    ThreadManager threadManager = ThreadManager.getInstance();


                    PojoError PojoError = gson.fromJson(response.errorBody().charStream(),PojoError.class);
                    Log.e("hey", "errorCOde is: " + PojoError.getErrorCode());
                    Log.e("hey", "errorMessage is: " + PojoError.getMessage());
                    if(PojoError.getErrorCode() == 1){

                        ErrorHandler.unExpectedResponseDialog(act);
                    }

                    if(PojoError.getErrorCode() == 0) {
                        if(SharedPrefs.TokenManager.tokenInvalidated(act)){
                            Transactor.authActivity(act);
                        }
                    }

                    else if(PojoError.getErrorCode() == 18 || PojoError.getErrorCode() == 17) {
                        MiddleMan.addToCallAgain(request);
                        if(!threadManager.isFreezed()) {
                            threadManager.freezeThread();


                            AuthRequest r = new RefreshToken(act);
                            r.setupCall();
                            r.makeCall();

                            Answers.getInstance().logCustom(new CustomEvent("Token")
                                    .putCustomAttribute("token", "refresh the token")
                            );
                        }
                        // too many requests
                    }else if(PojoError.getErrorCode() == 19){
                        if(!threadManager.isDelayed()) {
                            threadManager.startDelay();

                            MiddleMan.cancelAndSaveAllRequests();
                            MiddleMan.addToCallAgain(request);
                        }else {
                            MiddleMan.addToCallAgain(request);
                        }
                        Answers.getInstance().logCustom(new CustomEvent("Request")
                                .putCustomAttribute("request", "to many requests")
                        );

                         /*
                         else if(PojoError.getErrorCode() == 19){
                              if(!Manager.ThreadManager.isDelayed()) {
                                   Manager.ThreadManager.startDelay();
                                   MiddleMan.addToRateLimitQueue(request);
                                   //    MiddleMan.cancelAndSaveAllRequests();
                              }else {
                                   MiddleMan.addToRateLimitQueue(request);
                          }
                              */

                    }else {
                        if(cOnResponse != null){
                            cOnResponse.onErrorResponse(PojoError);
                        }
                    }
                    String errorMessage =  PojoError.getMessage().substring(0, Math.min(PojoError.getMessage().length(), 100));;
                    Answers.getInstance().logCustom(new CustomEvent("Request error")
                            .putCustomAttribute("error code: ", PojoError.getErrorCode())
                            .putCustomAttribute("error message: ", errorMessage)
                            .putCustomAttribute("time: ", PojoError.getTime())
                    );
                }
                MiddleMan.gotRequestResponse(request);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                if(cOnResponse != null) {
                    cOnResponse.onFailure(call, t);
                }
                Toast.makeText(act, R.string.info_something_went_wrong, Toast.LENGTH_LONG).show();
            }
        };
        return callback;
    }


    default void callSpec(Activity act, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        call.enqueue(buildCallbackSpec(act, request, call, cOnResponse, gson));
    }

    default void callAgainSpec(Activity act, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        call.clone().enqueue(buildCallbackSpec(act, request, call, cOnResponse, gson));
        Log.e("hey", "CALL AGAIN");
    }

    default Callback<ResponseBody> buildCallbackSpec(Activity act, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        Callback<ResponseBody> callback = new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                Log.e("hey", "gotResponse");
                Log.e("hey", response.raw().toString());

                if(response.body() == null){
                    Log.e("hey", "response is null ");
                }
                if(response.isSuccessful()){ // response != null
                    Log.e("hey", "response.isSuccessful()");
                    callIsSuccessful(response);
                }


                else if(!response.isSuccessful()){ // response != null
                    ThreadManager threadManager = ThreadManager.getInstance();

                    PojoError PojoError = gson.fromJson(response.errorBody().charStream(),PojoError.class);
                    Log.e("hey", "errorCOde is: " + PojoError.getErrorCode());
                    Log.e("hey", "errorMessage is: " + PojoError.getMessage());
                    if(PojoError.getErrorCode() == 1){
                        ErrorHandler.unExpectedResponseDialog(act);
                    }

                    if(PojoError.getErrorCode() == 0) {
                        if(SharedPrefs.TokenManager.tokenInvalidated(act)){
                            Intent i = new Intent(act, MainActivity.class);

                            act.startActivity(i);
                        }

                    }else if(PojoError.getErrorCode() == 19){
                        if(!threadManager.isDelayed()) {
                            threadManager.startDelay();
                            MiddleMan.addToRateLimitQueue(request);
                            //    MiddleMan.cancelAndSaveAllRequests();
                        }else {
                            MiddleMan.addToRateLimitQueue(request);
                        }

                        Answers.getInstance().logCustom(new CustomEvent("Request")
                                .putCustomAttribute("request", "to many requests")
                        );

                    }else {
                        cOnResponse.onErrorResponse(PojoError);

                    }
                    String errorMessage =  PojoError.getMessage().substring(0, Math.min(PojoError.getMessage().length(), 100));;
                    Answers.getInstance().logCustom(new CustomEvent("Request error")
                            .putCustomAttribute("error code: ", PojoError.getErrorCode())
                            .putCustomAttribute("error message: ", errorMessage)
                            .putCustomAttribute("time: ", PojoError.getTime())
                    );
                }
                MiddleMan.gotRequestResponse(request);
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

    void cancelRequest();
}

