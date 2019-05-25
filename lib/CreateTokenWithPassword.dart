import 'HazizzRequest.dart';
import 'HttpMethod.dart';
import 'communication/pojos/ResponseHandler.dart';

class CreateTokenWithPassword extends HazizzRequest{
  CreateTokenWithPassword(Map<String, dynamic> body, ResponseHandler rh) : super(rh){
   // MyHomePage({Key key, this.title}) : super(key: key);

    this.body = body;
    httpMethod = HttpMethod.POST;
    PATH = "auth/accesstoken";
    putContentTypeHeader();

  }
}