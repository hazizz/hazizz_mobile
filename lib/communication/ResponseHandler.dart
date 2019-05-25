import 'package:dio/dio.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';


class ResponseHandler {
 Function(Response response) onSuccessful;
 Function(PojoError pojoError) onError;


 ResponseHandler({
  Function onSuccessful,
  Function onError
 })  : this.onSuccessful = onSuccessful,
      this.onError = onError;


  void onPOJOResponse(Object response){}
 //  void onFailure(Call<ResponseBody> call, Throwable t){}
 //  void onError(PojoError error){}
   void onSuccessfulResponse(){}
   void onNoConnection(){}
  // void getHeaders(Headers headers){}
   void getRawResponseBody(String rawResponseBody){}
}