//import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/exceptions/exceptions.dart';
import 'package:mobile/managers/TokenManager.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mobile/converters/PojoConverter.dart';


import '../../HttpMethod.dart';
import '../../hazizz_date.dart';
import '../ResponseHandler.dart';

//region The base request
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
  Map<String, dynamic> query = {};

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
//endregion

//region Second generation parent requests
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
//endregion

//region Auth server requests
//region Token requests
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
//endregion

class RegisterUser extends AuthRequest{
  RegisterUser({@required String b_username,@required String b_password, @required String b_emailAddress, ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.POST;
    PATH = "/account/register";
    body["username"] = b_username;
    body["emailAddress"] = b_emailAddress;
    body["password"] = b_password;
    body["consent"] = true;
    contentTypeHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}
//endregion

//region Hazizz server requests

class GetMyInfo extends HazizzRequest {
  GetMyInfo({ResponseHandler rh}) : super(rh) {
    PATH = "me/details";
    httpMethod = HttpMethod.GET;
    authTokenHeader = true;
  }

  @override
  convertData(Response response) {
    PojoMeInfo meInfo = PojoMeInfo.fromJson(response.data);
    return meInfo;
  }
}


class GetMyProfilePicture extends HazizzRequest {
  GetMyProfilePicture.mini({ResponseHandler rh}) : super(rh) {
    PATH = "me/picture";
    hardCodeReducer();
  }

  GetMyProfilePicture.full({ResponseHandler rh}) : super(rh) {
    PATH = "me/picture/full";
    hardCodeReducer();
  }

  void hardCodeReducer(){
    httpMethod = HttpMethod.GET;
    authTokenHeader = true;
  }

  @override
  convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoGroup> myGroups = iter.map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
    return myGroups;
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

//region Subject requests
class CreateSubject extends HazizzRequest {
  CreateSubject({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "group/${groupId}";
    authTokenHeader = true;
    contentTypeHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
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
//endregion

//region Task requests
class CreateTask extends HazizzRequest {
  CreateTask({ResponseHandler rh,  int groupId, int subjectId,
    @required  int b_taskType, @required String b_title,
    @required String b_description, @required DateTime b_deadline }) : super(rh) {
    httpMethod = HttpMethod.POST;
    if(groupId != null) {
      PATH = "tasks/groups/${groupId}";
    }else if(subjectId != null){
      PATH = "tasks/subjects/${subjectId}";
    } else{
      PATH = "tasks/me";
    }
    authTokenHeader = true;
    contentTypeHeader = true;

    body["taskType"] = b_taskType.toString();
    body["taskTitle"] = b_title;
    body["description"] = b_description;
    body["dueDate"] = hazizzRequestDateFormat(b_deadline);
  }
  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class EditTask extends HazizzRequest {
  EditTask({ResponseHandler rh, int groupId, @required int taskId,
    int subjectId, @required int b_taskType, @required String b_title,
    @required String b_description,@required  DateTime b_deadline }) : super(rh) {
    httpMethod = HttpMethod.PATCH;
    if(groupId != null) {
      PATH = "tasks/groups/${groupId}/${taskId}";
    }else if(subjectId != null){
      PATH = "tasks/subjects/${subjectId}/${taskId}";
    } else{
      PATH = "tasks/me/${taskId}";
    }
    authTokenHeader = true;
    contentTypeHeader = true;

    body["taskType"] = b_taskType;
    body["taskTitle"] = b_title;
    body["description"] = b_description;
    body["dueDate"] = hazizzRequestDateFormat(b_deadline);
  }
  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DeleteTask extends HazizzRequest {
  DeleteTask({ResponseHandler rh, int groupId, int subjectId, @required int taskId}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    if(groupId != null) {
      PATH = "tasks/groups/${groupId}/${taskId}";
    }else if(subjectId != null){
      PATH = "tasks/subjects/${subjectId}/${taskId}";
    } else{
      PATH = "tasks/me/${taskId}";
    }
    authTokenHeader = true;
    contentTypeHeader = true;
  }
  @override
  dynamic convertData(Response response) {
    return response;
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
//endregion

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

class GetGroupInviteLink extends HazizzRequest {
  GetGroupInviteLink({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${groupId}/invitelink";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    String link = response.data;
    return link;
  }
}

class CreateGroup extends HazizzRequest {
  CreateGroup({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${groupId}/invitelink";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    String link = response.data;
    return link;
  }
}

/*
class GetGroupInviteLink extends HazizzRequest {
  GetGroupInviteLink({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${groupId}/invitelink";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    String link = response.data;
    return link;
  }
}
*/

//endregion

//region Thera server requests
//region Kreta requests
//region Kreta session requests
class KretaGetSessions extends TheraRequest {
  KretaGetSessions({ResponseHandler rh}) : super(rh) {
  httpMethod = HttpMethod.GET;
  PATH = "kreta/sessions";
  authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoSession> sessions = iter.map<PojoSession>((json) => PojoSession.fromJson(json)).toList();
    return sessions;
  }
}

class KretaCreateSession extends TheraRequest {
  KretaCreateSession({ResponseHandler rh, @required String b_username, @required String b_password, @required String b_url}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "kreta/sessions";
    authTokenHeader = true;
    contentTypeHeader = true;

    print("well boys we didit");

    print(b_username);
    print(b_password);
    print(b_url);

    body["username"] = b_username;
    body["password"] = b_password;
    body["url"] = b_url;

  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class KretaDeleteSessions extends TheraRequest {
  KretaDeleteSessions({ResponseHandler rh, @required String p_session}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    PATH = "kreta/sessions/${p_session}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class KretaAuthenticateSessions extends TheraRequest {
  KretaAuthenticateSessions({ResponseHandler rh, @required String p_session, @required String b_password}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "kreta/sessions/${p_session}/auth";
    authTokenHeader = true;
    contentTypeHeader = true;

    body["password"] = b_password;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}
//endregion

class KretaGetGrades extends TheraRequest {
  KretaGetGrades({ResponseHandler rh, @required int p_session}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "kreta/sessions/${p_session}/grades";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
  //  Iterable iter = getIterable(response.data);
   // List<PojoSession> grades = iter.map<PojoSession>((json) => PojoSession.fromJson(json)).toList();
    
    PojoGrades pojoGrades = PojoGrades.fromJson(jsonDecode(response.data));
    
    return pojoGrades;
  }
}

class KretaGetSchedules extends TheraRequest {
  KretaGetSchedules({ResponseHandler rh, @required int p_session, int q_weekNumber, int q_year}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "v2/kreta/sessions/${p_session}/schedule";
    authTokenHeader = true;

    if(q_weekNumber != null && q_year != null) {
      query["weekNumber"] = q_weekNumber;
      query["year"] = q_year;
    }else{
      print("query is required");
    }

  }

  @override
  dynamic convertData(Response response) {
    PojoSchedules schedules = PojoSchedules.fromJson(jsonDecode(response.data));
    return schedules;
  }
}



class DummyKretaGetGrades extends TheraRequest {
  DummyKretaGetGrades({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "dummy/grades";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    print(response.data);
    PojoGrades pojoGrades = PojoGrades.fromJson(jsonDecode(response.data));

    return pojoGrades;
  }
}

class DummyKretaGetSchedules extends TheraRequest {
  DummyKretaGetSchedules({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "dummy/schedule";
    authTokenHeader = true;

  }

  @override
  dynamic convertData(Response response) {
    print("schedule response: ${response.data}");
    PojoSchedules schedules = PojoSchedules.fromJson(jsonDecode(response.data));
    return schedules;
  }
}


class KretaGetSchools extends TheraRequest {
  KretaGetSchools({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "kreta/schools";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    final Map schools = json.decode(response.data);

    return schools;
  }
}
//endregion
//endregion