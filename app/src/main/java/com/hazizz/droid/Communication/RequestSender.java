package com.hazizz.droid.communication;

import android.util.Log;
import android.widget.Toast;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hazizz.droid.R;
import com.hazizz.droid.communication.requestTypes.AuthRequestTypes;
import com.hazizz.droid.communication.requestTypes.HazizzRequestTypes;
import com.hazizz.droid.communication.requestTypes.TheraRequestTypes;
import com.hazizz.droid.communication.requests.RequestType.Tokens.RefreshToken;
import com.hazizz.droid.communication.requests.parent.AuthRequest;
import com.hazizz.droid.communication.requests.parent.ParentRequest;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.manager.ThreadManager;
import com.hazizz.droid.navigation.Transactor;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RequestSender {

    private static final String BASE_URL = "https://hazizz.duckdns.org:9000/";
    private static final String PATH_HAZIZZ = "hazizz-server/";
    private static final String PATH_THERA = "thera-server/";
    private static final String PATH_AUTH = "auth-server/";

  //  public static final Gson gson = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation().create();
    public static Gson gson = new Gson();

    private static OkHttpClient okHttpClient = new OkHttpClient.Builder()
            .connectTimeout(5,TimeUnit.SECONDS)
            .writeTimeout(5, TimeUnit.SECONDS)
            .readTimeout(5, TimeUnit.SECONDS)
            .build();

    private static Retrofit retrofit_hazizz;
    private static Retrofit retrofit_auth;
    private static Retrofit retrofit_thera;
    private static Retrofit getAuthRetrofit(){
        if(retrofit_auth != null){
            return retrofit_auth;
        }
        retrofit_auth = new Retrofit.Builder()
                .baseUrl(BASE_URL + PATH_AUTH)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                .build();
        return retrofit_auth;
    }
    private static Retrofit getHazizzRetrofit(){
        if(retrofit_hazizz != null){
            return retrofit_hazizz;
        }
        retrofit_hazizz = new Retrofit.Builder()
                .baseUrl(BASE_URL + PATH_HAZIZZ)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                .build();
        return retrofit_hazizz;
    }
    private static Retrofit getTheraRetrofit(){
        if(retrofit_thera != null){
            return retrofit_thera;
        }
        retrofit_thera = new Retrofit.Builder()
                .baseUrl(BASE_URL + PATH_THERA)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(okHttpClient)
                .build();
        return retrofit_thera;
    }

    public static AuthRequestTypes getAuthRequestTypes(){
        return getAuthRetrofit().create(AuthRequestTypes.class);
    }
    public static TheraRequestTypes getTheraRequestTypes(){
        return getTheraRetrofit().create(TheraRequestTypes.class);
    }
    public static HazizzRequestTypes getHazizzRequestTypes(){
        return getHazizzRetrofit().create(HazizzRequestTypes.class);
    }


    public static void callAsync(ParentRequest request){
        request.getCall().enqueue(buildCallback(request));
    }

    public static void callAgainAsync(ParentRequest request){
        request.getCall().clone().enqueue(buildCallback(request));
        Log.e("hey", "CALL AGAIN");
    }

    public static void callSync(ParentRequest request){
        try {
            Response<ResponseBody> response = request.getCall().execute();
            try {
                request.callIsSuccessful(response);
            }catch (Exception e2){
                try {
                    PojoError error = Converter.fromJson(response.errorBody().charStream(), PojoError.class);
                    request.getOnResponse().onErrorResponse(error);
                }catch (Exception e3){
                    e3.printStackTrace();
                }
            }
        } catch (IOException e1) {
            e1.printStackTrace();
            Log.e("hey", "exception");
        }
    }

    public void callAgainSync(ParentRequest request){
        Log.e("hey", "CALL AGAIN");
        try {
            Response<ResponseBody> response = request.getCall().clone().execute();
            try {
                request.callIsSuccessful(response);
            }catch (Exception e2){
                try {
                    PojoError error = Converter.fromJson(response.errorBody().charStream(), PojoError.class);
                    request.getOnResponse().onErrorResponse(error);
                }catch (Exception e3){
                    e3.printStackTrace();
                }
            }
        } catch (IOException e1) {
            e1.printStackTrace();
            Log.e("hey", "exception");
        }
    }



    public static Callback<ResponseBody> buildCallback(ParentRequest request){
        Callback<ResponseBody> callback = new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                processResponse(response, request);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                if(request.getOnResponse() != null) {
                    request.getOnResponse().onFailure(call, t);
                }
                Toast.makeText(request.getContext(), R.string.info_something_went_wrong, Toast.LENGTH_LONG).show();
            }
        };
        return callback;
    }

    public static void processResponse(Response<ResponseBody> response, ParentRequest request) {
        Log.e("hey", "gotResponse");
        Log.e("hey", response.raw().toString());

        if(response.body() == null){
            Log.e("hey", "response is null ");
        }
        if(response.isSuccessful()){ // response != null
            Log.e("hey", "response.isSuccessful()");
            request.callIsSuccessful(response);
        }
        if(!response.isSuccessful()){ // response != null
            ThreadManager threadManager = ThreadManager.getInstance();

          //  PojoError pojoError = Converter.fromJson(response.errorBody().charStream(),PojoError.class);
           // Gson gson2 = new Gson();

            PojoError pojoError = gson.fromJson(response.errorBody().charStream(),PojoError.class);
            Log.e("hey", "errorCode is: " + pojoError.getErrorCode());
            Log.e("hey", "errorMessage is: " + pojoError.getMessage());

               /* TODO
               if(pojoError.getErrorCode() == 1){
                   ErrorHandler.unExpectedResponseDialog(act);
               }
               */
            switch(ErrorCode.fromInt(pojoError.getErrorCode())){
                case UNKNOWN_ERROR:
                    // Toast.makeText(co);
                    Log.e("hey", "switch unknown error: 0");
                    break;
                case ACCOUNT_LOCKED:
                case ACCOUNT_DISABLED:
                case ACCOUNT_EXPIRED:
                    Transactor.activityAuth(request.getContext());
                    break;

                case BAD_AUTHENTICATION_REQUEST:
                case INVALID_TOKEN:
                    MiddleMan.addToCallAgain(request);
                    if(!threadManager.isFreezed()) {
                        threadManager.freezeThread();

                        AuthRequest r = new RefreshToken(request.getContext());
                        r.setupCall();
                        RequestSender.callAsync(r);
                       // r.makeCall();

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
                    if(request.getOnResponse() != null){
                        request.getOnResponse().onErrorResponse(pojoError);
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


}
