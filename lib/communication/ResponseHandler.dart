
import 'package:mobile/communication/pojos/Pojo.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/packages/hazizz-dio-2.1.3/lib/dio.dart';


class ResponseHandler {

 Function(dynamic data) onSuccessful;
 Function(dynamic data) convertData;
 Function(dynamic data) processData;
 Function(dynamic data) onReceivedData;
 Function(dynamic data) addToBloc;
 Function(Response response) onSuccessfulRaw;
 Function(PojoError pojoError) onError;

 ResponseHandler({
  Function onSuccessful,
  Function onError
 })  : this.onSuccessful = onSuccessful,
      this.onError = onError;

 addToBlocFunc(Function blocFunc(dynamic data)){
  addToBloc = blocFunc;
 }

 void callBloc(dynamic data){
  addToBloc(data);
 }

  void onPOJOResponse(Object response){}
 //  void onFailure(Call<ResponseBody> call, Throwable t){}
 //  void onError(PojoError error){}
   void onSuccessfulResponse(){}
   void onNoConnection(){}
  // void getHeaders(Headers headers){}
   void getRawResponseBody(String rawResponseBody){}
}