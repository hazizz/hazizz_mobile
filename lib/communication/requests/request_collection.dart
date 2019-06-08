//import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/PojoSubject.dart';
import 'package:hazizz_mobile/communication/pojos/PojoTokens.dart';
import 'package:hazizz_mobile/communication/pojos/PojoUser.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/exceptions/exceptions.dart';
import 'package:hazizz_mobile/managers/TokenManager.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hazizz_mobile/converters/PojoConverter.dart';

import '../../HttpMethod.dart';
import '../ResponseHandler.dart';

class Request {
  dynamic responseData;

  BehaviorSubject subject;

  bool authTokenHeader = false;
  bool contentTypeHeader = false;

  static final String BASE_URL = "https://hazizz.duckdns.org:9000/";
  String SERVER_PATH;
  String PATH;
  ResponseHandler rh;

  Request(ResponseHandler rh){
    this.rh = rh;
  }

  Request.bloc(dynamic subject){
    this.subject = subject;
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
    if(this.rh.onSuccessful != null) {
      responseData = convertData(response.data);
      processData(responseData);

      // rh.onSuccessful(response);
      rh.addToBloc(responseData);
      rh.onReceivedData(responseData);
    }
  }

  void onError(PojoError pojoError){
    responseData = pojoError;
    rh?.onError(pojoError);
  }

  dynamic convertData(Response response){
    throw new ConverterNotImplementedException();
    return response;
  }

  void processData(dynamic data){

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

  @override
  dynamic convertData(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    return tokens;
  }

  @override
  void processData(data) {
    TokenManager.setToken(data.token);
    TokenManager.setRefreshToken(data.refresh);
  }

  @override
  void onSuccessful(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    TokenManager.setToken(tokens.token);
    TokenManager.setRefreshToken(tokens.refresh);
    rh.onSuccessful(tokens);
    rh.callBloc(tokens);
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

  @override
  void onSuccessful(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    TokenManager.setToken(tokens.token);
    TokenManager.setRefreshToken(tokens.refresh);
    rh.onSuccessful(tokens);
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

  @override
  void onSuccessful(Response response) {
    PojoTaskDetailed task = PojoTaskDetailed.fromJson(jsonDecode(response.data));
    rh.onSuccessful(task);
  }
}

class GetTasksFromMe extends HazizzRequest {
  GetTasksFromMe({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/tasks";
    authTokenHeader = true;
  }

  @override
  void onSuccessful(Response response) {
    // TODO: implement onSuccessful
    Iterable iter = getIterable(response.data);
    List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    myTasks.sort();
    rh?.onSuccessful(myTasks);
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    myTasks.sort();
    return myTasks;
  }
}

class GetMyGroups extends HazizzRequest {
  GetMyGroups({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/groups";
    authTokenHeader = true;
  }

  @override
  void onSuccessful(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoGroup> myGroups = iter.map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
    rh.onSuccessful(myGroups);
  }

  @override
  convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoGroup> myGroups = iter.map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
    return myGroups;
  }

}

class GetSubjects extends HazizzRequest {
  GetSubjects({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "subjects/group/${groupId}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoSubject> subjects = iter.map<PojoSubject>((json) => PojoSubject.fromJson(json)).toList();

    return subjects;
  }

  @override
  void onSuccessful(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoSubject> subjects =  iter.map<PojoSubject>((json) => PojoSubject.fromJson(json)).toList();

    rh?.onSuccessful(subjects);
  }
}

class CreateTask extends HazizzRequest {
  CreateTask({ResponseHandler rh, int groupId, int subjectId, int b_taskType, String b_title, String b_description, DateTime b_deadline }) : super(rh) {
    httpMethod = HttpMethod.POST;
    if(groupId != null) {
      PATH = "tasks/groups/${groupId}";
    }else if(subjectId != null){
      PATH = "tasks/subjects/${subjectId}";
    } else{
      PATH = "tasks/me";
    }
    authTokenHeader = true;
   // contentTypeHeader = true;

    body["taskType"] = b_taskType;
    body["taskTitle"] = b_title;
    body["description"] = b_description;
    body["dueDate"] = DateFormat("yyyy-MM-dd").format(b_deadline);
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }

  @override
  void onSuccessful(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoSubject> subjects =  iter.map<PojoSubject>((json) => PojoSubject.fromJson(json)).toList();

    rh?.onSuccessful(subjects);
  }
}

class GetTasksFromGroup extends HazizzRequest {
  GetTasksFromGroup({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "tasks/groups/${groupId}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    myTasks.sort();
    return myTasks;
  }
}

class GetGroupMembers extends HazizzRequest {
  GetGroupMembers({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${groupId}/users";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoUser> members = iter.map<PojoUser>((json) => PojoUser.fromJson(json)).toList();
    return members;
  }
}

