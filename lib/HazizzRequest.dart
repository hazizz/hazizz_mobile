import 'Request.dart';
import 'communication/pojos/ResponseHandler.dart';

class HazizzRequest extends Request{

  HazizzRequest(ResponseHandler rh) : super(rh){
    super.SERVER_PATH = "hazizz-server/";
  }

}