import 'package:dio/dio.dart';


class ResponseHandler {
 Function(Response) onResponse;
 Function(Response) onErrorResponse;


 ResponseHandler({
  Function onResponse
 })  : this.onResponse = onResponse;


  void onPOJOResponse(Object response){}
 //  void onFailure(Call<ResponseBody> call, Throwable t){}
 //  void onErrorResponse(PojoError error){}
   void onSuccessfulResponse(){}
   void onNoConnection(){}
  // void getHeaders(Headers headers){}
   void getRawResponseBody(String rawResponseBody){}
}