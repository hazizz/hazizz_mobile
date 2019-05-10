package com.hazizz.droid.communication;


import retrofit2.Callback;
import retrofit2.Response;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.google.gson.Gson;
import com.hazizz.droid.communication.requests.parent.AuthRequest;
import com.hazizz.droid.communication.requests.RequestType.Tokens.RefreshToken;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.R;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.manager.ThreadManager;

import okhttp3.ResponseBody;
import retrofit2.Call;

public interface RequestInterface {

     void setupCall();

     default void call(Context context, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
          call.enqueue(buildCallback(context, request, call, cOnResponse, gson));
     }

     default void callAgain(Context context, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
          call.clone().enqueue(buildCallback(context, request, call, cOnResponse, gson));
          Log.e("hey", "CALL AGAIN");
     }

     default Callback<ResponseBody> buildCallback(Context context, RequestInterface request, Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
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

                         PojoError pojoError = gson.fromJson(response.errorBody().charStream(),PojoError.class);
                         Log.e("hey", "errorCOde is: " + pojoError.getErrorCode());
                         Log.e("hey", "errorMessage is: " + pojoError.getMessage());

                    /* TODO
                    if(pojoError.getErrorCode() == 1){
                        ErrorHandler.unExpectedResponseDialog(act);
                    }
                    */
                         switch(ErrorCode.fromInt(pojoError.getErrorCode())){
                              case UNKNOWN_ERROR:
                                   // Toast.makeText(co);
                                   break;
                              case ACCOUNT_LOCKED:
                              case ACCOUNT_DISABLED:
                              case ACCOUNT_EXPIRED:
                                   Transactor.authActivity(context);
                                   break;

                              case BAD_AUTHENTICATION_REQUEST:
                              case INVALID_TOKEN:
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
                                   break;
                              case RATE_LIMIT_REACHED:
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
                                   break;
                              default:
                                   if(cOnResponse != null){
                                        cOnResponse.onErrorResponse(pojoError);
                                   }
                                   break;
                         }

                         String errorMessage =  pojoError.getMessage().substring(0, Math.min(pojoError.getMessage().length(), 100));;
                         Answers.getInstance().logCustom(new CustomEvent("Request error")
                                 .putCustomAttribute("error code: ", pojoError.getErrorCode())
                                 .putCustomAttribute("error message: ", errorMessage)
                                 .putCustomAttribute("time: ", pojoError.getTime())
                         );
                    }
                    MiddleMan.gotRequestResponse(request);
               }
               @Override
               public void onFailure(Call<ResponseBody> call, Throwable t) {
                    if(cOnResponse != null) {
                         cOnResponse.onFailure(call, t);
                    }
                    Toast.makeText(context, R.string.info_something_went_wrong, Toast.LENGTH_LONG).show();
               }
          };
          return callback;
     }

     void makeCall();

     void makeCallAgain();

     void callIsSuccessful(Response<ResponseBody> response);

     void cancelRequest();
}

