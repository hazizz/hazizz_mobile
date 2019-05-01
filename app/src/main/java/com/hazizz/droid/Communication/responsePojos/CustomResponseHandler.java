package com.hazizz.droid.Communication.responsePojos;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public interface CustomResponseHandler {
    default void onPOJOResponse(Object response){}
    default void onFailure(Call<ResponseBody> call, Throwable t){}
    default void onErrorResponse(PojoError error){}
    default void onSuccessfulResponse(){}
    default void onNoConnection(){}
    default void getHeaders(Headers headers){}
    default void getRawResponseBody(String rawResponseBody){}

}