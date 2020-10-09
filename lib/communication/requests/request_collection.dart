import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/communication/pojos/PojoAlertSettings.dart';
import 'package:mobile/communication/pojos/PojoGradeAvarage.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoGroupDetailed.dart';
import 'package:mobile/communication/pojos/PojoGroupPermissions.dart';
import 'package:mobile/communication/pojos/PojoInviteLink.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';
import 'package:mobile/communication/pojos/PojoKretaProfile.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoMyDetailedInfo.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTheraHealth.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/pojos/pojo_custom_class.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/managers/server_url_manager.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:meta/meta.dart';
import 'package:mobile/services/pojo_converter_helper.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:package_info/package_info.dart';
import 'dart:core';
import '../htttp_method_enum.dart';

import 'package:mobile/extension_methods/datetime_extension.dart';

Future<Request> refreshTokenInRequest(Request request) async {
  request.header[HttpHeaders.authorizationHeader] = (await TokenManager.tokens).token;
  return request;
}

//region Base request
class Request {
  dynamic responseData;

  bool includeAuthTokenHeader = false;
  bool contentTypeHeader = false;

 // String baseUrl = ServerUrlManager.serverUrl;
  String get baseUrl => ServerUrlManager.serverUrl;
  String serverPath = "";
  String path = "";

  HttpMethod httpMethod = HttpMethod.GET;

  String get url{
    return baseUrl + serverPath + path;
  }

  Future<Map<String, dynamic>> buildHeader() async{
    HazizzLogger.printLog("Building header: 1");
    PackageInfo p = await PackageInfo.fromPlatform();
    HazizzLogger.printLog("Building header: 2");
    header["User-Agent"] = "HM-${p.version}";

    HazizzLogger.printLog("Building header: 3");
    if(includeAuthTokenHeader){
      header[HttpHeaders.authorizationHeader] = "Bearer ${(await TokenManager.tokens).token}";
    }if(contentTypeHeader) {
      header[HttpHeaders.contentTypeHeader] = "application/json";
    }

    HazizzLogger.printLog("Built header");
    return header;
  }

  Map<String, dynamic> header = {};
  dynamic body = {};
  Map<String, dynamic> query = {};

  dynamic convertData(Response response){
    HazizzLogger.printLog("log: WARNING: convertData function not implemented");
    return null;
  }
}
//endregion

//region Second parent requests
class HazizzRequest extends Request{
  HazizzRequest() {
    super.serverPath = "hazizz-server/";
    serverPath = "hazizz-server/";
  }
}
class TheraRequest extends Request{
  TheraRequest() {
    super.serverPath = "thera-server/";
    serverPath = "thera-server/";
  }
}
class AuthRequest extends Request{
  AuthRequest() {
    super.serverPath = "auth-server/";
    serverPath = "auth-server/";
    query["client_id"] = "H_MOBILE";
  }
}
//endregion

//region Auth server requests
//region Token requests

class PingGatewayServer extends Request{
  PingGatewayServer(){
    httpMethod = HttpMethod.GET;
    path = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}

class PingAuthServer extends AuthRequest{
  PingAuthServer(){
    httpMethod = HttpMethod.GET;
    path = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}
class PingHazizzServer extends HazizzRequest{
  PingHazizzServer(){
    httpMethod = HttpMethod.GET;
    path = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}
class PingTheraServer extends TheraRequest{

  PingTheraServer(){
    httpMethod = HttpMethod.GET;
    path = "actuator/health";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return PojoTheraHealth.fromJson(jsonDecode(response.data));
  }
}


class CreateToken extends AuthRequest{
  void hardCodeReducer(){
    httpMethod = HttpMethod.POST;
    path = "auth";
  }
  CreateToken.withPassword({String qUsername, String qPassword}) {

    hardCodeReducer();
    query["grant_type"] = "password";
    query["username"] = qUsername;
    query["password"] = qPassword;
  }

  CreateToken.withRefresh({@required String qUsername, @required  String qRefreshToken, }) {
    hardCodeReducer();

    query["grant_type"] = "refresh_token";
    query["username"] = qUsername;
    query["refresh_token"] = qRefreshToken;
  }

  CreateToken.withGoogleAccount({@required String qOpenIdToken}) {
    hardCodeReducer();

    query["grant_type"] = "google_openid";
    query["openid_token"] = qOpenIdToken;
  }

  CreateToken.withFacebookAccount({@required String qFacebookToken}) {
    hardCodeReducer();

    query["grant_type"] = "facebook_token";
    query["facebook_token"] = qFacebookToken;
  }

  @override
  convertData(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    print("TOKENS PLS DELETE: ${tokens.toString()}");
    return tokens;
  }

  @override
  String toString() {
    return "Instance of 'CreateToken': $path";
  }
}


//endregion

class RegisterWithGoogleAccount extends AuthRequest{
  RegisterWithGoogleAccount({@required String bOpenIdToken}) {
    httpMethod = HttpMethod.POST;
    path = "account/googleregister";
    body["openIdToken"] = bOpenIdToken;
    body["consent"] = true;
    contentTypeHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class RegisterWithFacebookAccount extends AuthRequest{
  RegisterWithFacebookAccount({@required String bFacebookToken}) {
    httpMethod = HttpMethod.POST;
    path = "account/facebookregister";
    body["facebookToken"] = bFacebookToken;
    body["consent"] = true;
    contentTypeHeader = true;
  }

  @override
  dynamic convertData(Response response) {

    return response;
  }
}

class Information extends AuthRequest{
  Information(){
    httpMethod = HttpMethod.GET;
    path = "information/detailed";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DeleteMe extends AuthRequest{
  DeleteMe({@required int pUserId}) {
    httpMethod = HttpMethod.DELETE;
    path = "users/$pUserId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class GetFirebaseTokens extends AuthRequest{
  GetFirebaseTokens({@required int pUserId}){
    httpMethod = HttpMethod.GET;
    path = "users/$pUserId/firebasetokens";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class AddFirebaseToken extends AuthRequest{
  AddFirebaseToken({@required int pUserId, @required String bFirebaseToken}){
    httpMethod = HttpMethod.POST;
    path = "users/$pUserId/firebasetokens";
    includeAuthTokenHeader = true;

    body = bFirebaseToken;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class RemoveFirebaseTokens extends AuthRequest{
  RemoveFirebaseTokens({@required int pUserId, @required String firebaseToken}){
    httpMethod = HttpMethod.DELETE;
    path = "users/$pUserId/firebasetokens";
    includeAuthTokenHeader = true;

    body = firebaseToken;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

//endregion

//region Hazizz server requests

class GetMyInfo extends AuthRequest {
  bool isPublic;
  GetMyInfo.public()  {
    path = "information/detailed";
    httpMethod = HttpMethod.GET;
    includeAuthTokenHeader = true;

    isPublic = true;
  }

  GetMyInfo.private()  {
    path = "information/detailed";
    httpMethod = HttpMethod.GET;
    includeAuthTokenHeader = true;

    isPublic = false;
  }

  @override
  convertData(Response response) {
    return PojoMyDetailedInfo.fromRawJson(response.data);
  }
}


class GetUserProfilePicture extends HazizzRequest {
  GetUserProfilePicture.mini({ @required int pUserId})  {
    path = "users/$pUserId/picture";
    hardCodeReducer();
  }

  GetUserProfilePicture.full({ @required int pUserId})  {
    path = "users/$pUserId/picture/full";
    hardCodeReducer();
  }

  void hardCodeReducer(){
    httpMethod = HttpMethod.GET;
    includeAuthTokenHeader = true;
  }

  @override
  convertData(Response response) {
    String encodedProfilePic = jsonDecode(response.data)["data"];
    encodedProfilePic = encodedProfilePic.split(",")[1];
    return encodedProfilePic;
  }
}

class GetMyProfilePicture extends HazizzRequest {
  GetMyProfilePicture.mini()  {
    path = "users/${CacheManager.getMyIdSafely}/picture";
    hardCodeReducer();
  }

  GetMyProfilePicture.full()  {
    path = "users/${CacheManager.getMyIdSafely}/picture/full";
    hardCodeReducer();
  }

  void hardCodeReducer(){
    httpMethod = HttpMethod.GET;
    includeAuthTokenHeader = true;
  }

  @override
  convertData(Response response) {
    String encodedProfilePic = jsonDecode(response.data)["data"];
    encodedProfilePic = encodedProfilePic.split(",")[1];
    return encodedProfilePic;
  }
}

class UpdateMyProfilePicture extends HazizzRequest {
  UpdateMyProfilePicture({ @required String encodedImage})  {
    path = "users/${CacheManager.getMyIdSafely}/picture";
    httpMethod = HttpMethod.POST;
    includeAuthTokenHeader = true;
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
  UpdateMyDisplayName({ @required String  bDisplayName})  {
    path = "users/${CacheManager.getMyIdSafely}/displayname";
    httpMethod = HttpMethod.POST;
    includeAuthTokenHeader = true;
    contentTypeHeader = true;
    body["displayName"] =  bDisplayName;
  }

  @override
  convertData(Response response) => PojoMeInfo.fromJson(jsonDecode(response.data));
}


class Report extends HazizzRequest {
  void hardCodeReducer( String description){
    httpMethod = HttpMethod.POST;
    includeAuthTokenHeader = true;

    contentTypeHeader = true;
   // body["title"] = title;
    body = description;
  }

  Report.group({ @required int pGroupId, @required String bDescription})  {
    path = "groups/$pGroupId/report";
    hardCodeReducer( bDescription);
  }

  Report.subject({@required int pGroupId, @required int pSubjectId, @required String bDescription})  {
    path = "subjects/$pSubjectId/report";
    hardCodeReducer( bDescription);
  }

  Report.task({ @required int pTaskId, @required String bDescription})  {
    path = "tasks/$pTaskId/report";
    hardCodeReducer( bDescription);
  }

  Report.comment({ @required int pCommentId, @required int pTaskId, @required String bDescription})  {
    path = "comments/$pCommentId/report";
    hardCodeReducer(bDescription);
  }

  Report.user({ @required int pUserId, @required String bDescription})  {
    path = "users/$pUserId/report";
    hardCodeReducer(bDescription);
  }

  @override
  convertData(Response response) {
    return response;
  }
}

class CreateGroup extends HazizzRequest {
  CreateGroup.open({ @required String  bGroupName})  {
    httpMethod = HttpMethod.POST;
    path = "groups";
    includeAuthTokenHeader = true;
    contentTypeHeader = true;
    body["groupName"] =  bGroupName;
    body["type"] = "OPEN";
  }

  CreateGroup.closed({ @required String  bGroupName})  {
    httpMethod = HttpMethod.POST;
    path = "groups";
    includeAuthTokenHeader = true;
    contentTypeHeader = true;
    body["groupName"] =  bGroupName;
    body["type"] = "CLOSED";
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


  RetrieveGroup({ @required int pGroupId,})  {
    httpMethod = HttpMethod.GET;
    path = "groups/$pGroupId";
    includeAuthTokenHeader = true;
  }

  RetrieveGroup.details({ @required int pGroupId,})  {
    httpMethod = HttpMethod.GET;
    path = "groups/$pGroupId/details";
    includeAuthTokenHeader = true;
    isDetailed = true;
  }

  RetrieveGroup.withoutMe({ @required int pGroupId,})  {
    httpMethod = HttpMethod.GET;
    path = "groups/$pGroupId/withoutme";
    includeAuthTokenHeader = true;
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

  LeaveGroup({@required int pGroupId})  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/leavegroup/$pGroupId";
    includeAuthTokenHeader = true;
  }

  @override
  convertData(Response response) {
    return response;
  }
}

class JoinGroup extends HazizzRequest {

  bool isDetailed = false;
  bool isWithoutMe = false;

  JoinGroup({@required int pGroupId, String pPassword})  {
    httpMethod = HttpMethod.POST;
  //  path = "users/${CacheManager.getMyIdSafely}/joingroup/$pGroupId";
    path = pPassword == null
      ? "groups/$pGroupId/join"
      : "groups/$pGroupId/join/$pPassword";
    includeAuthTokenHeader = true;
  }

  /*
  JoinGroup.withPassword({ @required int pGroupId, @required String pPassword})  {
    httpMethod = HttpMethod.POST;
   // path = "users/${CacheManager.getMyIdSafely}/joingroup/$pGroupId/$pPassword";
    path = "groups/$pGroupId/join/$pPassword";
    includeAuthTokenHeader = true;
  }
  */

  @override
  convertData(Response response) => PojoGroupDetailed.fromJson(jsonDecode(response.data));
      
     // getIterable(response.data).map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
}


class PromoteMember extends HazizzRequest {

  void hardCodeReducer(int g, int u){
    httpMethod = HttpMethod.POST;
    path = "groups/$g/permissions/$u";
    includeAuthTokenHeader = true;
  }

  PromoteMember.toModerator({ @required int pGroupId, @required int pUserId,})  {
    hardCodeReducer(pGroupId, pUserId);
    body["permission"] = "MODERATOR";
  }

  PromoteMember.toUser({ @required int pGroupId, @required int pUserId})  {
    hardCodeReducer(pGroupId, pUserId);
    body["permission"] = "USER";
  }

  @override
  convertData(Response response) {
    return response;
  }
}

class GetMyGroups extends HazizzRequest {
  GetMyGroups()  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/groups";
    includeAuthTokenHeader = true;
  }

  @override
  convertData(Response response) => getIterable(response.data)
      .map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
}

//region Subject requests
class DeleteSubject extends HazizzRequest {
  DeleteSubject({ @required int pSubjectId})  {
    httpMethod = HttpMethod.DELETE;
    path = "subjects/$pSubjectId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class CreateSubject extends HazizzRequest {
  CreateSubject({ @required int pGroupId, @required String bSubjectName, bool bSubscriberOnly = false})  {
    httpMethod = HttpMethod.POST;
    path = "subjects/groups/$pGroupId";
    includeAuthTokenHeader = true;
    contentTypeHeader = true;
    body["name"] = bSubjectName;
    body["subscriberOnly"] = bSubscriberOnly;
  }

  @override
  dynamic convertData(Response response) => PojoSubject.fromJson(jsonDecode(response.data));
}

class UpdateSubject extends HazizzRequest {
  UpdateSubject({ @required int pSubjectId, @required String bSubjectName, bool bSubscriberOnly = false})  {
    httpMethod = HttpMethod.PATCH;
    path = "subjects/$pSubjectId";
    includeAuthTokenHeader = true;
    contentTypeHeader = true;
    body["name"] = bSubjectName;
    body["subscriberOnly"] = bSubscriberOnly;
  }

  @override
  dynamic convertData(Response response) => PojoSubject.fromJson(jsonDecode(response.data));

}

class SubscribeToSubject extends HazizzRequest {
  SubscribeToSubject({ @required int pSubjectId,})  {
    httpMethod = HttpMethod.POST;
    path = "subjects/$pSubjectId/subscribed";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class UnsubscribeFromSubject extends HazizzRequest {
  UnsubscribeFromSubject({ @required int pSubjectId,})  {
    httpMethod = HttpMethod.DELETE;
    path = "subjects/$pSubjectId/subscribed";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class GetSubjects extends HazizzRequest {
  GetSubjects({ int pGroupId})  {
    httpMethod = HttpMethod.GET;
    path = "subjects/groups/$pGroupId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoSubject> subjects = iter.map<PojoSubject>((json) => PojoSubject.fromJson(json)).toList();

    return subjects;
  }
}
//endregion

//region Task requests
class CreateTask extends HazizzRequest {
  CreateTask({  int pGroupId, int pSubjectId,
    @required  List<String> bTags, @required String bDescription,
    @required DateTime bDeadline, String bSalt })  {
    httpMethod = HttpMethod.POST;
    if(pSubjectId != null && pSubjectId != 0){
      path = "tasks/subjects/$pSubjectId";
    }else if(pGroupId != null && pGroupId != 0) {
      path = "tasks/groups/$pGroupId";
    } else{
      path = "tasks/me";
    }
    includeAuthTokenHeader = true;
    contentTypeHeader = true;

    body["tags"] = bTags;
    body["description"] = bDescription == null ? "" : bDescription;
    body["dueDate"] = bDeadline.hazizzRequestDateFormat;
    if(bSalt != null && bSalt != ""){
      body["salt"] = bSalt;
    }
  }
  @override
  dynamic convertData(Response response) {
    var task = PojoTask.fromJson(jsonDecode(response.data));
    return task;
  }
}

class EditTask extends HazizzRequest {
  EditTask({ @required int pTaskId,
    @required List<String> bTags,
    @required String bDescription,@required  DateTime bDeadline, String bSalt})  {
    httpMethod = HttpMethod.PATCH;
    path = "tasks/$pTaskId";

    includeAuthTokenHeader = true;
    contentTypeHeader = true;

    body["tags"] = bTags;
    body["description"] = bDescription;
    body["dueDate"] = bDeadline.hazizzRequestDateFormat;
    if(bSalt != null && bSalt != ""){
      body["salt"] = bSalt;
    }
  }
  @override
  dynamic convertData(Response response) {
    var task = PojoTask.fromJson(jsonDecode(response.data));
    return task;
  }
}

class DeleteTask extends HazizzRequest {
  DeleteTask({@required int pTaskId})  {
    httpMethod = HttpMethod.DELETE;
    path = "tasks/$pTaskId";
    includeAuthTokenHeader = true;
    contentTypeHeader = true;
  }
  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class GetTaskByTaskId extends HazizzRequest {
  GetTaskByTaskId({ int pTaskId})  {
    httpMethod = HttpMethod.GET;
    path = "tasks/$pTaskId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoTaskDetailed task = PojoTaskDetailed.fromJson(jsonDecode(response.data));
    return task;
  }
}

class GetAlertSettings extends HazizzRequest {
  GetAlertSettings({ @required int qUserId})  {
    httpMethod = HttpMethod.GET;
    path = "users/$qUserId/alertsettings";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoAlertSettings alertSetting = PojoAlertSettings.fromJson(jsonDecode(response.data));
    return alertSetting;
  }
}

class UpdateAlertSettings extends HazizzRequest {
  UpdateAlertSettings({ @required int qUserId, @required String bAlarmTime,
  @required bool bMondayEnabled, @required bool bTuesdayEnabled, @required bool bWednesdayEnabled,
  @required bool bThursdayEnabled, @required bool bFridayEnabled, @required bool bSaturdayEnabled,
  @required bool bSundayEnabled})  {
    httpMethod = HttpMethod.POST;
    path = "users/$qUserId/alertsettings";
    includeAuthTokenHeader = true;

    body["alarmTime"] = bAlarmTime;
    body["mondayEnabled"] = bMondayEnabled;
    body["tuesdayEnabled"] = bTuesdayEnabled;
    body["wednesdayEnabled"] = bWednesdayEnabled;
    body["thursdayEnabled"] = bThursdayEnabled;
    body["fridayEnabled"] = bFridayEnabled;
    body["saturdayEnabled"] = bSaturdayEnabled;
    body["sundayEnabled"] = bSundayEnabled;
  }

  @override
  dynamic convertData(Response response) {
   // PojoAlertSettings alertSetting = PojoAlertSettings.fromJson(jsonDecode(response.data));
    return response;
  }
}


class GetRecentEvents extends HazizzRequest {
  GetRecentEvents()  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/notifications";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

//ha pGroupId != 0 és subject = 0
//akkor csak a csoporthoz rendeltet küldi vissza
class GetTasksFromMe extends HazizzRequest {
  GetTasksFromMe({
    bool qShowThera = true,
    bool qUnfinishedOnly, bool qFinishedOnly,
    List<String> qTags, String qStartingDate,
    String qEndDate, int qGroupId,
    int qSubjectId, qWholeGroup = false
  })  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/tasks";
    includeAuthTokenHeader = true;

    if(qShowThera != null)    query["showThera"] = qShowThera;
    if(qUnfinishedOnly != null )query["unfinishedOnly"] = qUnfinishedOnly;
    if(qFinishedOnly != null )query["finishedOnly"] = qFinishedOnly;
    if(qTags != null )query["tags"] = qTags;
    if(qStartingDate != null )query["startingDate"] = qStartingDate;
    if(qEndDate != null )query["endDate"] = qEndDate;
    if(qGroupId != null )query["groupId"] = qGroupId;
    if(qSubjectId != null )query["subjectId"] = qSubjectId;
    if(qWholeGroup != null )query["wholeGroup"] = qWholeGroup;
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
  SetTaskCompleted({ @required int pTaskId, @required bool setCompleted})  {
    includeAuthTokenHeader = true;
    path = "tasks/$pTaskId/completed";

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
  GetTasksFromGroup({ int pGroupId})  {
    httpMethod = HttpMethod.GET;
    path = "tasks/groups/$pGroupId";
    includeAuthTokenHeader = true;
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
  GetTaskComments({ int pTaskId})  {
    httpMethod = HttpMethod.GET;
    path = "comments/tasks/$pTaskId/chat";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoComment> taskComments = iter.map<PojoComment>((json) => PojoComment.fromJson(json)).toList();
    return taskComments;
  }
}

class CreateTaskComment extends HazizzRequest {
  CreateTaskComment({ @required int pTaskId, @required String bContent})  {
    httpMethod = HttpMethod.POST;
    path = "comments/tasks/$pTaskId/chat";
    includeAuthTokenHeader = true;
    body["content"] = bContent;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DeleteComment extends HazizzRequest {
  DeleteComment({ @required int pCommentId})  {
    httpMethod = HttpMethod.DELETE;
    path = "comments/$pCommentId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class GetGroupMembers extends HazizzRequest {
  GetGroupMembers({ int pGroupId})  {
    httpMethod = HttpMethod.GET;
    path = "groups/$pGroupId/users";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoUser> members = iter.map<PojoUser>((json) => PojoUser.fromJson(json)).toList();
    return members;
  }
}


class GetGroupMemberPermissions extends HazizzRequest {
  GetGroupMemberPermissions({ int pGroupId})  {
    httpMethod = HttpMethod.GET;
    path = "groups/$pGroupId/permissions";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoGroupPermissions p = PojoGroupPermissions.fromJson(jsonDecode(response.data));
    return p;
  }
}

class KickGroupMember extends HazizzRequest {
  KickGroupMember({ @required int pGroupId, @required int pUserId})  {
    httpMethod = HttpMethod.DELETE;
    path = "groups/$pGroupId/users/$pUserId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}



class GetGroupInviteLinks extends HazizzRequest {

  GetGroupInviteLinks({ @required int pGroupId})  {
    httpMethod = HttpMethod.GET;
    path = "groups/$pGroupId/invitelinks";
    includeAuthTokenHeader = true;
  }
  /*
  etGroupInviteLinks.open({ @required int pGroupId})  {
    httpMethod = HttpMethod.GET;
    PATH = "groups/$groupId/invitelinks";
    authTokenHeader = true;
  }

  GetGroupInviteLinks.closed({ @required int pGroupId,  @required int groupPassword})  {
    httpMethod = HttpMethod.GET;
    PATH = "s/groups/$groupId/$groupPassword";
    authTokenHeader = true;
  }
  */

  @override
  dynamic convertData(Response response) {
   // return response;//response.headers.value("Location");

    Iterable iter = getIterable(response.data);
    List<PojoInviteLink> links = iter.map<PojoInviteLink>((json) => PojoInviteLink.fromJson(json)).toList();
    return links;

  }
}

class CreateGroupInviteLink extends HazizzRequest {
  CreateGroupInviteLink({ @required int pGroupId})  {
    httpMethod = HttpMethod.POST;
    path = "groups/$pGroupId/invitelinks";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    // return response;//response.headers.value("Location");
    return PojoInviteLink.fromJson(jsonDecode(response.data));

  }
}

class RemoveGroupInviteLink extends HazizzRequest {
  RemoveGroupInviteLink({ @required int pGroupId, @required int pInviteId})  {
    httpMethod = HttpMethod.DELETE;
    path = "groups/$pGroupId/invitelinks/$pInviteId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

/*
class GetGroupInviteLink extends HazizzRequest {
  GetGroupInviteLink({ @required int pGroupId})  {
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

class KretaGetSession extends TheraRequest {
  KretaGetSession({@required int sessionId})  {
    httpMethod = HttpMethod.GET;
    path = "kreta/sessions/$sessionId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoSession session = PojoSession.fromJson(jsonDecode(response.data));
    return session;
  }
}

class KretaGetSessions extends TheraRequest {
  KretaGetSessions()  {
    httpMethod = HttpMethod.GET;
    path = "kreta/sessions";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoSession> sessions = iter.map<PojoSession>((json) => PojoSession.fromJson(json)).toList();
    return sessions;
  }
}

class KretaGetProfile extends TheraRequest {
  KretaGetProfile({ @required PojoSession session})  {
    httpMethod = HttpMethod.GET;
    path = "kreta/sessions/${session.id}/profile";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoKretaProfile profile = PojoKretaProfile.fromJson(jsonDecode(response.data));
    return profile;
  }
}

class KretaCreateSession extends TheraRequest {
  KretaCreateSession({ @required String bUsername, @required String bPassword, @required String bUrl})  {
    httpMethod = HttpMethod.POST;
    path = "kreta/sessions";
    includeAuthTokenHeader = true;
    contentTypeHeader = true;

    body["username"] = bUsername;
    body["password"] = bPassword;
    body["url"] = bUrl;

  }

  @override
  dynamic convertData(Response response) {
    PojoSession session = PojoSession.fromJson(jsonDecode(response.data));

    return session;
  }
}

class KretaRemoveSessions extends TheraRequest {
  KretaRemoveSessions({ @required int pSession})  {
    httpMethod = HttpMethod.DELETE;
    path = "kreta/sessions/${pSession.toString()}";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class KretaAuthenticateSession extends TheraRequest {
  KretaAuthenticateSession({ @required int pSession, @required String bPassword})  {
    httpMethod = HttpMethod.POST;
    path = "kreta/sessions/$pSession/auth";
    includeAuthTokenHeader = true;
    contentTypeHeader = true;

    body["password"] = bPassword;

  }

  @override
  dynamic convertData(Response response) {

    PojoSession session = PojoSession.fromJson(jsonDecode(response.data));

    return session;
  }
}
//endregion


class KretaGetNotes extends TheraRequest {
  KretaGetNotes()  {
    httpMethod = HttpMethod.GET;
    path = "kreta/sessions/${KretaSessionManager.selectedSession.id}/notes";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {

    Iterable iter = getIterable(response.data);
    List<PojoKretaNote> notes = iter.map<PojoKretaNote>((json) => PojoKretaNote.fromJson(json)).toList();

    return notes;
  }
}

class KretaGetGrades extends TheraRequest {
  KretaGetGrades()  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/grades";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoGrades pojoGrades = PojoGrades.fromJson(jsonDecode(response.data));
    return pojoGrades;
  }
}

class KretaGetGradesWithSession extends TheraRequest {
  KretaGetGradesWithSession()  {
    httpMethod = HttpMethod.GET;
    path = "kreta/sessions/${KretaSessionManager.selectedSession.id}/grades";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    //  Iterable iter = getIterable(response.data);
    // List<PojoSession> grades = iter.map<PojoSession>((json) => PojoSession.fromJson(json)).toList();

    PojoGrades pojoGrades = PojoGrades.fromJson(jsonDecode(response.data));

    return pojoGrades;
  }
}

class KretaGetGradeAverages extends TheraRequest {
  KretaGetGradeAverages()  {
    httpMethod = HttpMethod.GET;
    path = "kreta/sessions/${SelectedSessionBloc().selectedSession.id}/averages";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoGradeAverage> averages = iter.map<PojoGradeAverage>((json) => PojoGradeAverage.fromJson(json)).toList();
    return averages;
  }
}

class KretaGetSchedules extends TheraRequest {
  KretaGetSchedules({ int qWeekNumber, int qYear})  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/schedules";
    includeAuthTokenHeader = true;

    if(qWeekNumber != null && qYear != null) {
      query["weekNumber"] = qWeekNumber.toString();
      query["year"] = qYear.toString();
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
  KretaGetSchedulesWithSession({ int qWeekNumber, int qYear})  {
    httpMethod = HttpMethod.GET;
    path = "v2/kreta/sessions/${KretaSessionManager.selectedSession.id}/schedule";
    includeAuthTokenHeader = true;

    if(qWeekNumber != null && qYear != null) {
      query["weekNumber"] = qWeekNumber.toString();
      query["year"] = qYear.toString();
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


class GetCustomSchedule extends TheraRequest {
  GetCustomSchedule()  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/schedules/custom";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    Iterable iter = getIterable(response.data);
    List<PojoCustomClass> schedule = iter.map<PojoCustomClass>((json) => PojoCustomClass.fromJson(json)).toList();
    return schedule;
  }
}

class GetCustomClass extends TheraRequest {
  GetCustomClass({ int customClassId})  {
    httpMethod = HttpMethod.GET;
    path = "users/${CacheManager.getMyIdSafely}/schedules/custom/$customClassId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return PojoCustomClass.fromJson(jsonDecode(response.data));
  }
}

class CreateCustomClass extends TheraRequest {
  CreateCustomClass({
    String recurrenceRule = "FREQ=WEEKLY;INTERVAL=1;WKST=MO;BYDAY=WE",
    @required String start, @required String end, bool wholeDay = false, @required int periodNumber,
    @required String title, @required String description, @required String host, @required String location
  })  {
    httpMethod = HttpMethod.POST;
    path = "users/${CacheManager.getMyIdSafely}/schedules/custom";
    includeAuthTokenHeader = true;
    body["recurrenceRule"] =  recurrenceRule;
    body["start"] =  start;
    body["end"] =  end;
    body["wholeDay"] =  wholeDay;
    body["periodNumber"] =  periodNumber;
    body["title"] =  title;
    body["description"] =  description;
    body["host"] =  host;
    body["location"] =  location;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DeleteCustomClass extends TheraRequest {
  DeleteCustomClass({int customClassId})  {
    httpMethod = HttpMethod.DELETE;
    path = "users/${CacheManager.getMyIdSafely}/schedules/custom/$customClassId";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DummyKretaGetGrades extends TheraRequest {
  DummyKretaGetGrades()  {
    httpMethod = HttpMethod.GET;
    path = "dummy/grades";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoGrades pojoGrades = PojoGrades.fromJson(jsonDecode(response.data));
    return pojoGrades;
  }
}

class DummyKretaGetSchedules extends TheraRequest {
  DummyKretaGetSchedules()  {
    httpMethod = HttpMethod.GET;
    path = "dummy/schedule";
    includeAuthTokenHeader = true;

  }

  @override
  dynamic convertData(Response response) {
    PojoSchedules schedules = PojoSchedules.fromJson(jsonDecode(response.data));
    return schedules;
  }
}


class KretaGetSchools extends TheraRequest {
  KretaGetSchools()  {
    httpMethod = HttpMethod.GET;
    path = "kreta/schools";
    includeAuthTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    final Map schools = json.decode(response.data);

    return schools;
  }
}
//endregion
//endregion