import 'package:http/http.dart' as http;
import 'dart:io';
import 'HttpMethod.dart';
import 'communication/pojos/ResponseHandler.dart';

class Request {
  static final String BASE_URL = "https://hazizz.duckdns.org:9000/";
  String SERVER_PATH = "hazizz-server/";
  String PATH = "/tasks";
  ResponseHandler rh;

  Request(ResponseHandler rh){
    this.rh = rh;
  }


  HttpMethod httpMethod = HttpMethod.GET;

 // final String _url = "this will be built";
  String get url{
    return BASE_URL + SERVER_PATH + PATH;
  }

  void putContentTypeHeader(){
    header[HttpHeaders.contentTypeHeader] = "application/json";
  }

  Map<String, dynamic> header = {HttpHeaders.authorizationHeader : "Bearer " + "getAuthToken"};
  Map<String, dynamic> body = null;
}
