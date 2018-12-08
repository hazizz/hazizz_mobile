package com.indeed.hazizz.Communication.POJO.Response;

import android.util.Log;

import com.google.gson.Gson;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
 import android.content.Context;
        import android.util.Log;

        import com.google.gson.Gson;
        import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
        import com.indeed.hazizz.Communication.POJO.Response.POJOauth;
        import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
        import com.indeed.hazizz.Communication.POJO.Response.ResponseInterface;

        import org.json.JSONObject;

        import java.util.HashMap;

        import okhttp3.ResponseBody;
        import retrofit2.Call;
        import retrofit2.Callback;
        import retrofit2.Response;

public class RequestParent {
    /* protected Context context;
     protected HashMap<String, Object> body;
     protected CustomResponseHandler cOnResponse;
     protected HashMap<String, Object> vars; */

    public void setupCall(){}
    public void call(Call<ResponseBody> call, CustomResponseHandler cOnResponse, Gson gson){
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                Log.e("hey", "gotResponse");
                Log.e("hey", response.raw().toString());

                if(response.body() == null){
                    Log.e("hey", "response is null ");
                }

                if(response.isSuccessful()){ // response != null
                    Log.e("hey", "response.isSuccessful()");
                    callIsSuccessful( response);
                }

                if(!response.isSuccessful()){ // response != null
                    POJOerror pojoError = gson.fromJson(response.errorBody().charStream(),POJOerror.class);
                    Log.e("hey", "errorCOde is: " +pojoError.getErrorCode());
                    cOnResponse.onErrorResponse(pojoError);
                }
                else{cOnResponse.onEmptyResponse();}
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                cOnResponse.onFailure(call, t);
            }
        });
    }
    public void callIsSuccessful(Response<ResponseBody> response){}

}
