import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:flutter_hazizz/managers/TokenManager.dart';

import '../../HttpMethod.dart';
import '../ResponseHandler.dart';

class Request {
  bool authTokenHeader = false;
  bool contentTypeHeader = false;

  static final String BASE_URL = "https://hazizz.duckdns.org:9000/";
  String SERVER_PATH;
  String PATH;
  ResponseHandler rh;

  Request(ResponseHandler rh){
    this.rh = rh;
  }

  HttpMethod httpMethod = HttpMethod.GET;

  String get url{
    return BASE_URL + SERVER_PATH + PATH;
  }

  Future<Map<String, dynamic>> buildHeader() async{
    if(authTokenHeader){
      header[HttpHeaders.authorizationHeader] = "Bearer ${await TokenManager.getToken()}";
    }if(contentTypeHeader) {
      header[HttpHeaders.contentTypeHeader] = "application/json";
    }
    return header;
  }

  Map<String, dynamic> header = {};
  Map<String, dynamic> body = {};

  void onSuccessful(Response response){
    rh.onSuccessful(response);
  }

  void onError(PojoError pojoError){
    rh.onError(pojoError);
  }


}

class HazizzRequest extends Request{
  HazizzRequest(ResponseHandler rh) : super(rh){
    super.SERVER_PATH = "hazizz-server/";
    SERVER_PATH = "hazizz-server/";
  }
}
class TheraRequest extends Request{
  TheraRequest(ResponseHandler rh) : super(rh){
    super.SERVER_PATH = "thera-server/";
    SERVER_PATH = "thera-server/";
  }
}
class AuthRequest extends Request{
  AuthRequest(ResponseHandler rh) : super(rh){
    super.SERVER_PATH = "auth-server/";
    SERVER_PATH = "auth-server/";
  }
}

class CreateTokenWithPassword extends AuthRequest{
  CreateTokenWithPassword({String b_username, String b_password, ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.POST;
    PATH = "auth/accesstoken";

    body["username"] = b_username;
    body["password"] = b_password;
    contentTypeHeader = true;
  }
}

class CreateTokenWithRefresh extends AuthRequest{
  CreateTokenWithRefresh({String b_username, String b_refreshToken, ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.POST;
    PATH = "auth/accesstoken";

    body["username"] = b_username;
    body["refreshToken"] = b_refreshToken;
    contentTypeHeader = true;
  }


}

class CreateElevationToken extends AuthRequest{
  CreateElevationToken({String b_password, ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.POST;
    PATH = "auth/elevationtoken";

    body["password"] = b_password;
    contentTypeHeader = true;
  }

}

class GetTaskByTaskId extends HazizzRequest {
  GetTaskByTaskId({ResponseHandler rh, int p_taskId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "tasks/${p_taskId}";
    authTokenHeader = true;
  }
}

class GetTasksFromMe extends HazizzRequest {
  GetTasksFromMe({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/tasks";
    authTokenHeader = true;
  }
}

class GetMyGroups extends HazizzRequest {
  GetMyGroups({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/groups";
    authTokenHeader = true;
  }
}





