//import 'dart:convert';
import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoGradeAvarage.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoGroupDetailed.dart';
import 'package:mobile/communication/pojos/PojoGroupPermissions.dart';
import 'package:mobile/communication/pojos/PojoInviteLink.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';
import 'package:mobile/communication/pojos/PojoKretaProfile.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/group_types_enum.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mobile/converters/PojoConverter.dart';

import 'package:mobile/custom/hazizz_date.dart';
import '../ResponseHandler.dart';
import '../htttp_methods.dart';

Future<Request> refreshTokenInRequest(Request request) async {
  request.header[HttpHeaders.authorizationHeader] = await TokenManager.getToken();

  return request;
}

//region The base request
class Request {
  dynamic responseData;

  BehaviorSubject subject;

  bool authTokenHeader = false;
  bool contentTypeHeader = false;

  static const String BASE_URL = "https://hazizz.duckdns.org:9000/";
  String SERVER_PATH = "";
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
    HazizzLogger.printLog("Building header: 1");
    PackageInfo p = await PackageInfo.fromPlatform();
    HazizzLogger.printLog("Building header: 2");
    header["User-Agent"] = "HM-${p.version}";
  /*
    if(HazizzAppInfo().getInfo == null){
      PackageInfo p = await PackageInfo.fromPlatform();
      header["User-Agent"] = "HM-${p.version}";
    }else {
      header["User-Agent"] = "HM-${HazizzAppInfo().getInfo.version}";
    }
    */
    HazizzLogger.printLog("Building header: 3");
    if(authTokenHeader){
      header[HttpHeaders.authorizationHeader] = "Bearer ${await TokenManager.getToken()}";
    }if(contentTypeHeader) {
      header[HttpHeaders.contentTypeHeader] = "application/json";
    }

    HazizzLogger.printLog("Built header");
    return header;
  }

  Map<String, dynamic> header = {};
  dynamic body = {};
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
    HazizzLogger.printLog("log: WARNING: convertData function not implemented");
   // throw new ConverterNotImplementedException();
    return null;
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
    query["client_id"] = "H_MOBILE";
  }
}
//endregion

//region Auth server requests
//region Token requests

class PingGatewayServer extends Request{
  PingGatewayServer({ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}

class PingAuthServer extends AuthRequest{
  PingAuthServer({ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}
class PingHazizzServer extends HazizzRequest{
  PingHazizzServer({ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}
class PingTheraServer extends TheraRequest{
  PingTheraServer({ResponseHandler rh}) : super(rh){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}


class CreateToken extends AuthRequest{
  void hardCodeReducer(){
    httpMethod = HttpMethod.POST;
    PATH = "auth";
  }
  CreateToken.withPassword({String q_username, String q_password, ResponseHandler rh}) : super(rh){

    hardCodeReducer();
    query["grant_type"] = "password";
    query["username"] = q_username;
    query["password"] = q_password;
  }

  CreateToken.withRefresh({@required String q_username, @required  String q_refreshToken, ResponseHandler rh}) : super(rh){
    hardCodeReducer();

    query["grant_type"] = "refresh_token";
    query["username"] = q_username;
    query["refresh_token"] = q_refreshToken;
  }

  CreateToken.withGoogleAccount({@required String q_openIdToken}) : super(null){
    hardCodeReducer();

    query["grant_type"] = "google_openid";
    query["openid_token"] = q_openIdToken;
  }

  CreateToken.withFacebookAccount({@required String q_facebookToken}) : super(null){
    hardCodeReducer();

    query["grant_type"] = "facebook_token";
    query["facebook_token"] = q_facebookToken;
  }

  @override
  convertData(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    print("TOKENS PLS DELETE: ${tokens.toString()}");
    return tokens;
  }


  @override
  String toString() {
    return "Instance of 'CreateToken': $PATH";
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

class RegisterWithGoogleAccount extends AuthRequest{
  RegisterWithGoogleAccount({@required String b_openIdToken}) : super(null){
    httpMethod = HttpMethod.POST;
    PATH = "account/googleregister";
    body["openIdToken"] = b_openIdToken;
    body["consent"] = true;
    contentTypeHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class RegisterWithFacebookAccount extends AuthRequest{
  RegisterWithFacebookAccount({@required String b_facebookToken}) : super(null){

    httpMethod = HttpMethod.POST;
    PATH = "account/facebookregister";
    body["facebookToken"] = b_facebookToken;
    body["consent"] = true;
    contentTypeHeader = true;

  }

  @override
  dynamic convertData(Response response) {

    return response;
  }
}

class Information extends AuthRequest{
  Information() : super(null){
    httpMethod = HttpMethod.GET;
    PATH = "information/detailed";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DeleteMe extends AuthRequest{
  DeleteMe({@required int userId}) : super(null){
    httpMethod = HttpMethod.DELETE;
    PATH = "users/${userId}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}



//endregion

//region Hazizz server requests


class GetMyInfo extends HazizzRequest {
  bool isPublic;
  GetMyInfo.public({ResponseHandler rh}) : super(rh) {
    PATH = "me";
    httpMethod = HttpMethod.GET;
    authTokenHeader = true;

    isPublic = true;
  }

  GetMyInfo.private({ResponseHandler rh}) : super(rh) {
    PATH = "me/details";
    httpMethod = HttpMethod.GET;
    authTokenHeader = true;

    isPublic = false;
  }

  @override
  convertData(Response response) {

    PojoMeInfoPrivate privat = PojoMeInfoPrivate.fromJson(jsonDecode(response.data));
    return privat;

    if(isPublic){
    //  PojoMeInfoPublic public = PojoMeInfoPublic.fromJson(jsonDecode(response.data));
    //  return public;
    }else{
      PojoMeInfoPrivate privat = PojoMeInfoPrivate.fromJson(jsonDecode(response.data));
      return privat;
    }
  }
}


class GetUserProfilePicture extends HazizzRequest {
  GetUserProfilePicture.mini({ResponseHandler rh, @required int userId}) : super(rh) {
    PATH = "users/$userId/picture";
    hardCodeReducer();
  }

  GetUserProfilePicture.full({ResponseHandler rh, @required int userId}) : super(rh) {
    PATH = "users/$userId/picture/full";
    hardCodeReducer();
  }

  void hardCodeReducer(){
    httpMethod = HttpMethod.GET;
    authTokenHeader = true;
  }

  @override
  convertData(Response response) {
    String encodedProfilePic = jsonDecode(response.data)["data"];
    encodedProfilePic = encodedProfilePic.split(",")[1];
    return encodedProfilePic;
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
    String encodedProfilePic = jsonDecode(response.data)["data"];
    encodedProfilePic = encodedProfilePic.split(",")[1];
    return encodedProfilePic;
  }
}

class UpdateMyProfilePicture extends HazizzRequest {
  UpdateMyProfilePicture({ResponseHandler rh, @required String encodedImage}) : super(rh) {
    PATH = "me/picture";
    httpMethod = HttpMethod.POST;
    authTokenHeader = true;
    contentTypeHeader = true;
    body["data"] = "data:image/jpeg;base64," + encodedImage;
  }

  @override
  convertData(Response response) {

    String encodedProfilePic = jsonDecode(response.data)["data"];
    encodedProfilePic = encodedProfilePic.split(",")[1];
    return encodedProfilePic;
  }
}

class UpdateMyDisplayName extends HazizzRequest {
  UpdateMyDisplayName({ResponseHandler rh, @required String b_displayName}) : super(rh) {
    PATH = "me/displayname";
    httpMethod = HttpMethod.POST;
    authTokenHeader = true;
    contentTypeHeader = true;
    body["displayName"] = b_displayName;
  }

  @override
  convertData(Response response) {
    PojoMeInfo meInfo = PojoMeInfo.fromJson(jsonDecode(response.data));
    return meInfo;
  }
}


class Report extends HazizzRequest {
  void hardCodeReducer( String description){
    httpMethod = HttpMethod.POST;
    authTokenHeader = true;

    contentTypeHeader = true;
   // body["title"] = title;
    body = description;
  }

  Report.group({ResponseHandler rh, @required int p_groupId, @required String b_description}) : super(rh) {
    PATH = "groups/$p_groupId/report";
    hardCodeReducer( b_description);
  }

  Report.subject({ResponseHandler rh,@required int p_groupId, @required int p_subjectId, @required String b_description}) : super(rh) {
    PATH = "subjects/group/$p_groupId/$p_subjectId/report";
    hardCodeReducer( b_description);
  }

  Report.task({ResponseHandler rh, @required int p_taskId, @required String b_description}) : super(rh) {
    PATH = "tasks/$p_taskId/report";
    hardCodeReducer( b_description);
  }

  Report.comment({ResponseHandler rh, @required int p_commentId, @required int p_taskId, @required String b_description}) : super(rh) {
    PATH = "tasks/$p_taskId/comments/$p_commentId/report";
    hardCodeReducer(b_description);
  }

  Report.user({ResponseHandler rh, @required int p_userId, @required String b_description}) : super(rh) {
    PATH = "users/$p_userId/report";
    hardCodeReducer(b_description);
  }

  @override
  convertData(Response response) {
    return response;
  }
}




class CreateGroup extends HazizzRequest {

  CreateGroup({ResponseHandler rh, @required String b_groupName, @required GroupType type, String b_password}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "groups";
    authTokenHeader = true;
    contentTypeHeader = true;
    body["groupName"] = b_groupName;
    body["type"] = valueOfGroupType(type);
    if(type == GroupType.PASSWORD){
      assert(b_password != null);
      body["password"] = b_password;
    }
  }

  @override
  convertData(Response response) {
    return response;
  }
}

// you can also join group with this
class RetrieveGroup extends HazizzRequest {

  bool isDetailed = false;
  bool isWithoutMe = false;


  RetrieveGroup({ResponseHandler rh, @required int p_groupId,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${p_groupId}";
    authTokenHeader = true;
  }

  RetrieveGroup.details({ResponseHandler rh, @required int p_groupId,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${p_groupId}/details";
    authTokenHeader = true;
    isDetailed = true;
  }

  RetrieveGroup.withoutMe({ResponseHandler rh, @required int p_groupId,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${p_groupId}/withoutme";
    authTokenHeader = true;
    isWithoutMe = true;
  }


  @override
  convertData(Response response) {
    if(isDetailed){
      PojoGroupDetailed group = PojoGroupDetailed.fromJson(jsonDecode(response.data));
      return group;
    }else if(isWithoutMe){
      PojoGroupWithoutMe group = PojoGroupWithoutMe.fromJson(jsonDecode(response.data));
      return group;
    }
    PojoGroup group = PojoGroup.fromJson(jsonDecode(response.data));
    return group;
  }
}

class LeaveGroup extends HazizzRequest {

  LeaveGroup({ResponseHandler rh, @required int p_groupId,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/leavegroup/$p_groupId";
    authTokenHeader = true;
  }


  @override
  convertData(Response response) {
    return response;
  }
}


class JoinGroup extends HazizzRequest {

  bool isDetailed = false;
  bool isWithoutMe = false;


  JoinGroup({ResponseHandler rh, @required int p_groupId,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/joingroup/$p_groupId";
    authTokenHeader = true;
  }

  JoinGroup.withPassword({ResponseHandler rh, @required int p_groupId, @required String p_password}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/joingroup/$p_groupId/$p_password";
    authTokenHeader = true;
  }



  @override
  convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoGroup> groups = iter.map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();

    return groups;
  }
}


class PromoteMember extends HazizzRequest {

  void hardCodeReducer(int g, int u){
    httpMethod = HttpMethod.POST;
    PATH = "groups/$g/permission/$u";
    authTokenHeader = true;
  }

  PromoteMember.toModerator({ResponseHandler rh, @required int p_groupId, @required int p_userId,}) : super(rh) {
    hardCodeReducer(p_groupId, p_userId);
    body["permission"] = "MODERATOR";
  }

  PromoteMember.toUser({ResponseHandler rh, @required int p_groupId, @required int p_userId}) : super(rh) {
    hardCodeReducer(p_groupId, p_userId);
    body["permission"] = "USER";
  }

  @override
  convertData(Response response) {
    return response;
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

class DeleteSubject extends HazizzRequest {
  DeleteSubject({ResponseHandler rh, @required int p_groupId, @required int p_subjectId}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    PATH = "subjects/group/$p_groupId/$p_subjectId";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}



class CreateSubject extends HazizzRequest {
  CreateSubject({ResponseHandler rh, @required int p_groupId, @required String b_subjectName, @required bool b_subscriberOnly = false}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "subjects/group/${p_groupId}";
    authTokenHeader = true;
    contentTypeHeader = true;
    body["name"] = b_subjectName;
    body["subscriberOnly"] = b_subscriberOnly;

  }

  @override
  dynamic convertData(Response response) {
    var newSubject = PojoSubject.fromJson(jsonDecode(response.data));
    return newSubject;
  }
}

class UpdateSubject extends HazizzRequest {
  UpdateSubject({ResponseHandler rh, @required int p_subjectId, @required String b_subjectName, @required bool b_subscriberOnly = false}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "subjects/${p_subjectId}";
    authTokenHeader = true;
    contentTypeHeader = true;
    body["name"] = b_subjectName;
    body["subscriberOnly"] = b_subscriberOnly;
  }

  @override
  dynamic convertData(Response response) {
    var editedSubject = PojoSubject.fromJson(jsonDecode(response.data));
    return editedSubject;
  }
}

class SubscribeToSubject extends HazizzRequest {
  SubscribeToSubject({ResponseHandler rh, @required int p_subjectId,}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "subjects/$p_subjectId/subscribed";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class UnsubscribeFromSubject extends HazizzRequest {
  UnsubscribeFromSubject({ResponseHandler rh, @required int p_subjectId,}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    PATH = "subjects/$p_subjectId/subscribed";
    authTokenHeader = true;
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
    @required  List<String> b_tags, @required String b_title,
    @required String b_description, @required DateTime b_deadline }) : super(rh) {
    httpMethod = HttpMethod.POST;
    if(subjectId != null && subjectId != 0){
      PATH = "tasks/subjects/${subjectId}";
    }else if(groupId != null && groupId != 0) {
      PATH = "tasks/groups/${groupId}";
    } else{
      PATH = "tasks/me";
    }
    authTokenHeader = true;
    contentTypeHeader = true;

    body["tags"] = b_tags;
    body["taskTitle"] = b_title;
    body["description"] = b_description == null ? "" : b_description;
    body["dueDate"] = hazizzRequestDateFormat(b_deadline);
  }
  @override
  dynamic convertData(Response response) {
    var task = PojoTask.fromJson(jsonDecode(response.data));
    return task;
  }
}

class EditTask extends HazizzRequest {
  EditTask({ResponseHandler rh, @required int taskId,
    @required List<String> b_tags, @required String b_title,
    @required String b_description,@required  DateTime b_deadline }) : super(rh) {
    httpMethod = HttpMethod.PATCH;
    PATH = "tasks/${taskId}";

    authTokenHeader = true;
    contentTypeHeader = true;

    body["tags"] = b_tags;
    body["taskTitle"] = b_title;
    body["description"] = b_description;
    body["dueDate"] = hazizzRequestDateFormat(b_deadline);

  }
  @override
  dynamic convertData(Response response) {
    var task = PojoTask.fromJson(jsonDecode(response.data));
    return task;
  }
}

class DeleteTask extends HazizzRequest {
  DeleteTask({ResponseHandler rh, int groupId, int subjectId, @required int taskId}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    /*
    if(groupId != null && groupId != 0) {
      PATH = "tasks/groups/${groupId}/${taskId}";
    }else if(subjectId != null && subjectId != 0){
      PATH = "tasks/subjects/${subjectId}/${taskId}";
    } else{
      PATH = "tasks/me/${taskId}";
    }
    */
    PATH = "tasks/${taskId}";
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

class GetRecentEvents extends HazizzRequest {
  GetRecentEvents({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "me/notifications";
    authTokenHeader = true;

  }

  @override
  dynamic convertData(Response response) {

    return response;
  }
}

//ha groupId != 0 és subject = 0
//akkor csak a csoporthoz rendeltet küldi vissza
class GetTasksFromMe extends HazizzRequest {
  GetTasksFromMe({ResponseHandler rh, bool q_showThera = true,
                  bool q_unfinishedOnly, bool q_finishedOnly,
                  List<String> q_tags, String q_startingDate,
                  String q_endDate, int q_groupId,
                  int q_subjectId, q_wholeGroup = false
  }) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "v2/me/tasks";
    authTokenHeader = true;

    if(q_showThera != null)    query["showThera"] = q_showThera;
    if(q_unfinishedOnly != null )query["unfinishedOnly"] = q_unfinishedOnly;
    if(q_finishedOnly != null )query["finishedOnly"] = q_finishedOnly;
    if(q_tags != null )query["tags"] = q_tags;
    if(q_startingDate != null )query["startingDate"] = q_startingDate;
    if(q_endDate != null )query["endDate"] = q_endDate;
    if(q_groupId != null )query["groupId"] = q_groupId;
    if(q_subjectId != null )query["subjectId"] = q_subjectId;
    if(q_wholeGroup != null )query["wholeGroup"] = q_wholeGroup;

  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    myTasks.sort();
    return myTasks;
  }
}

class SetTaskCompleted extends HazizzRequest {
  SetTaskCompleted({ResponseHandler rh, @required int p_taskId, @required bool setCompleted}) : super(rh) {
    authTokenHeader = true;
    PATH = "tasks/$p_taskId/completed";

    if(setCompleted){
      httpMethod = HttpMethod.POST;
    }else{
      httpMethod = HttpMethod.DELETE;
    }

  }

  @override
  dynamic convertData(Response response) {
    String isCompleted = response.data;
    if(isCompleted == "true"){
      return true;
    }
    return false;

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


class GetTaskComments extends HazizzRequest {
  GetTaskComments({ResponseHandler rh, int p_taskId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "comments/tasks/$p_taskId/chat";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoComment> taskComments = iter.map<PojoComment>((json) => PojoComment.fromJson(json)).toList();
    return taskComments;
  }
}

class CreateTaskComment extends HazizzRequest {
  CreateTaskComment({ResponseHandler rh, @required int p_taskId, @required String b_content}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "comments/tasks/$p_taskId/chat";
    authTokenHeader = true;
    body["content"] = b_content;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DeleteComment extends HazizzRequest {
  DeleteComment({ResponseHandler rh, @required int p_commentId}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    PATH = "comments/$p_commentId";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
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


class GetGroupMemberPermissions extends HazizzRequest {
  GetGroupMemberPermissions({ResponseHandler rh, int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${groupId}/permissions";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoGroupPermissions p = PojoGroupPermissions.fromJson(jsonDecode(response.data));
    return p;
  }
}

class KickGroupMember extends HazizzRequest {
  KickGroupMember({ResponseHandler rh, @required int p_groupId, @required int p_userId}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    PATH = "groups/$p_groupId/users/$p_userId";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}



class GetGroupInviteLinks extends HazizzRequest {
  GetGroupInviteLinks({ResponseHandler rh, @required int groupId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${groupId}/invitelinks";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoInviteLink> links = iter.map<PojoInviteLink>((json) => PojoInviteLink.fromJson(json)).toList();

    return links;
  }
}

class GetGroupInviteLink extends HazizzRequest {
  GetGroupInviteLink({ResponseHandler rh, @required int groupId}) : super(rh) {
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

class KretaGetProfile extends TheraRequest {
  KretaGetProfile({ResponseHandler rh, @required PojoSession session}) : super(rh) {
  httpMethod = HttpMethod.GET;
  PATH = "kreta/sessions/${session.id}/profile";
  authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoKretaProfile profile = PojoKretaProfile.fromJson(jsonDecode(response.data));
    return profile;
  }
}

class KretaCreateSession extends TheraRequest {
  KretaCreateSession({ResponseHandler rh, @required String b_username, @required String b_password, @required String b_url}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "kreta/sessions";
    authTokenHeader = true;
    contentTypeHeader = true;

    body["username"] = b_username;
    body["password"] = b_password;
    body["url"] = b_url;

  }

  @override
  dynamic convertData(Response response) {
    PojoSession session = PojoSession.fromJson(jsonDecode(response.data));

    return session;
  }
}

class KretaRemoveSessions extends TheraRequest {
  KretaRemoveSessions({ResponseHandler rh, @required int p_session}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    PATH = "kreta/sessions/${p_session.toString()}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class KretaAuthenticateSession extends TheraRequest {
  KretaAuthenticateSession({ResponseHandler rh, @required int p_session, @required String b_password}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "kreta/sessions/${p_session}/auth";
    authTokenHeader = true;
    contentTypeHeader = true;

    body["password"] = b_password;

  }

  @override
  dynamic convertData(Response response) {

    PojoSession session = PojoSession.fromJson(jsonDecode(response.data));

    return session;
  }
}
//endregion


class KretaGetNotes extends TheraRequest {
  KretaGetNotes({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "kreta/sessions/${KretaSessionManager.selectedSession.id}/notes";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {

    Iterable iter = getIterable(response.data);
    List<PojoKretaNote> notes = iter.map<PojoKretaNote>((json) => PojoKretaNote.fromJson(json)).toList();

    return notes;
  }
}

class KretaGetGrades extends TheraRequest {
  KretaGetGrades({ResponseHandler rh,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "grades";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoGrades pojoGrades = PojoGrades.fromJson(jsonDecode(response.data));
    return pojoGrades;
  }
}

class KretaGetGradesWithSession extends TheraRequest {
  KretaGetGradesWithSession({ResponseHandler rh,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "kreta/sessions/${KretaSessionManager.selectedSession.id}/grades";
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

class KretaGetGradeAvarages extends TheraRequest {
  KretaGetGradeAvarages({ResponseHandler rh,}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "kreta/sessions/${SelectedSessionBloc().selectedSession.id}/averages";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoGradeAvarage> avarages = iter.map<PojoGradeAvarage>((json) => PojoGradeAvarage.fromJson(json)).toList();
    return avarages;
  }
}

class KretaGetSchedules extends TheraRequest {
  KretaGetSchedules({ResponseHandler rh, int q_weekNumber, int q_year}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "schedules";
    authTokenHeader = true;

    if(q_weekNumber != null && q_year != null) {
      query["weekNumber"] = q_weekNumber.toString();
      query["year"] = q_year.toString();
    }else{
      DateTime now = DateTime.now();
      int dayOfYear = int.parse(DateFormat("D").format(now));
      int weekOfYear = ((dayOfYear - now.weekday + 10) / 7).floor();
      query["weekNumber"] = weekOfYear.toString();
      query["year"] = dayOfYear.toString();
    }
  }

  @override
  dynamic convertData(Response response) {
    try {
      PojoSchedules schedules = PojoSchedules.fromJson(
          jsonDecode(response.data));
      return schedules;
    }catch(e){
      return null;
    }
  }
}

class KretaGetSchedulesWithSession extends TheraRequest {
  KretaGetSchedulesWithSession({ResponseHandler rh, int q_weekNumber, int q_year}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "v2/kreta/sessions/${KretaSessionManager.selectedSession.id}/schedule";
    authTokenHeader = true;

    if(q_weekNumber != null && q_year != null) {
      query["weekNumber"] = q_weekNumber.toString();
      query["year"] = q_year.toString();
    }else{
      DateTime now = DateTime.now();
      int dayOfYear = int.parse(DateFormat("D").format(now));
      int weekOfYear = ((dayOfYear - now.weekday + 10) / 7).floor();
      query["weekNumber"] = weekOfYear.toString();
      query["year"] = dayOfYear.toString();
    }
  }

  @override
  dynamic convertData(Response response) {
    try {
      PojoSchedules schedules = PojoSchedules.fromJson(
          jsonDecode(response.data));
      return schedules;
    }catch(e){
      return null;
    }
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