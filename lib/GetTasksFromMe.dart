import 'HazizzRequest.dart';
import 'communication/pojos/ResponseHandler.dart';

class GetTasksFromMe extends HazizzRequest {
  GetTasksFromMe( ResponseHandler rh) : super(rh){
    PATH = "/tasks";
    putContentTypeHeader();
  }
}
