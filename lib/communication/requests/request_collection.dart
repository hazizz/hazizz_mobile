import 'dart:convert';
import 'dart:io';

import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/communication/pojos/PojoAlertSettings.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoGradeAvarage.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoGroupDetailed.dart';
import 'package:mobile/communication/pojos/PojoGroupPermissions.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';
import 'package:mobile/communication/pojos/PojoKretaProfile.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoMyDetailedInfo.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTheraHealth.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/managers/preference_service.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:meta/meta.dart';
import 'package:mobile/services/pojo_converter_helper.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:package_info/package_info.dart';


import '../htttp_methods.dart';

import 'package:mobile/extension_methods/datetime_extension.dart';


Future<Request> refreshTokenInRequest(Request request) async {
  request.header[HttpHeaders.authorizationHeader] = await TokenManager.getToken();

  return request;
}

//region The base request
class Request {
  dynamic responseData;

  bool authTokenHeader = false;
  bool contentTypeHeader = false;

  String BASE_URL = PreferenceService.serverUrl;
  String SERVER_PATH = "";
  String PATH = "";


  HttpMethod httpMethod = HttpMethod.GET;

  String get url{
    return BASE_URL + SERVER_PATH + PATH;
  }

  Future<Map<String, dynamic>> buildHeader() async{
    HazizzLogger.printLog("Building header: 1");
    PackageInfo p = await PackageInfo.fromPlatform();
    HazizzLogger.printLog("Building header: 2");
    header["User-Agent"] = "HM-${p.version}";

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

  dynamic convertData(Response response){
    HazizzLogger.printLog("log: WARNING: convertData function not implemented");
    return null;
  }

  void processData(dynamic data){

  }
}
//endregion

//region Second gen parent requests
class HazizzRequest extends Request{
  HazizzRequest() {
    super.SERVER_PATH = "hazizz-server/";
    SERVER_PATH = "hazizz-server/";
  }
}
class TheraRequest extends Request{
  TheraRequest() {
    super.SERVER_PATH = "thera-server/";
    SERVER_PATH = "thera-server/";
  }
}
class AuthRequest extends Request{
  AuthRequest() {
    super.SERVER_PATH = "auth-server/";
    SERVER_PATH = "auth-server/";
    query["client_id"] = "H_MOBILE";
  }
}
//endregion

//region Auth server requests
//region Token requests

class PingGatewayServer extends Request{
  PingGatewayServer(){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}

class PingAuthServer extends AuthRequest{
  PingAuthServer(){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}
class PingHazizzServer extends HazizzRequest{
  PingHazizzServer(){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
  }

  @override
  dynamic convertData(Response response) {
    return response.data;
  }
}
class PingTheraServer extends TheraRequest{

  PingTheraServer(){
    httpMethod = HttpMethod.GET;
    PATH = "actuator/health";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return PojoTheraHealth.fromJson(jsonDecode(response.data));
  }
}


class CreateToken extends AuthRequest{
  void hardCodeReducer(){
    httpMethod = HttpMethod.POST;
    PATH = "auth";
  }
  CreateToken.withPassword({String q_username, String q_password, }) {

    hardCodeReducer();
    query["grant_type"] = "password";
    query["username"] = q_username;
    query["password"] = q_password;
  }

  CreateToken.withRefresh({@required String q_username, @required  String q_refreshToken, }) {
    hardCodeReducer();

    query["grant_type"] = "refresh_token";
    query["username"] = q_username;
    query["refresh_token"] = q_refreshToken;
  }

  CreateToken.withGoogleAccount({@required String q_openIdToken}) {
    hardCodeReducer();

    query["grant_type"] = "google_openid";
    query["openid_token"] = q_openIdToken;
  }

  CreateToken.withFacebookAccount({@required String q_facebookToken}) {
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
  RegisterUser({@required String b_username,@required String b_password, @required String b_emailAddress, }) {
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
  RegisterWithGoogleAccount({@required String b_openIdToken}) {
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
  RegisterWithFacebookAccount({@required String b_facebookToken}) {

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
  Information(){
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
  DeleteMe({@required int userId}) {
    httpMethod = HttpMethod.DELETE;
    PATH = "users/${userId}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class GetFirebaseTokens extends AuthRequest{
  GetFirebaseTokens({@required int userId}){
    httpMethod = HttpMethod.GET;
    PATH = "users/$userId/firebasetokens";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class AddFirebaseToken extends AuthRequest{
  AddFirebaseToken({@required int userId, @required String firebaseToken}){
    httpMethod = HttpMethod.POST;
    PATH = "users/$userId/firebasetokens";
    authTokenHeader = true;

    body = firebaseToken;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class RemoveFirebaseTokens extends AuthRequest{
  RemoveFirebaseTokens({@required int userId, @required String firebaseToken}){
    httpMethod = HttpMethod.DELETE;
    PATH = "users/$userId/firebasetokens";
    authTokenHeader = true;

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
    PATH = "information/detailed";
    httpMethod = HttpMethod.GET;
    authTokenHeader = true;

    isPublic = true;
  }

  GetMyInfo.private()  {
    PATH = "information/detailed";
    httpMethod = HttpMethod.GET;
    authTokenHeader = true;

    isPublic = false;
  }

  @override
  convertData(Response response) {
    return PojoMyDetailedInfo.fromRawJson(response.data);
  }
}


class GetUserProfilePicture extends HazizzRequest {
  GetUserProfilePicture.mini({ @required int userId})  {
    PATH = "users/$userId/picture";
    hardCodeReducer();
  }

  GetUserProfilePicture.full({ @required int userId})  {
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
  GetMyProfilePicture.mini()  {
    PATH = "users/${CacheManager.getMyIdSafely}/picture";
    hardCodeReducer();
  }

  GetMyProfilePicture.full()  {
    PATH = "users/${CacheManager.getMyIdSafely}/picture/full";
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
  UpdateMyProfilePicture({ @required String encodedImage})  {
    PATH = "users/${CacheManager.getMyIdSafely}/picture";
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
  UpdateMyDisplayName({ @required String b_displayName})  {
    PATH = "users/${CacheManager.getMyIdSafely}/displayname";
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

class UploadImage extends Request {
  UploadImage({ @required HazizzImageData imageData, @required String key, @required String iv})  {
   // package.Image im = package.decodeImage(image.readAsBytesSync());
    authTokenHeader = false;
    contentTypeHeader = false;
    BASE_URL = "https://transfer.sh/${Random().nextInt(1000)}.txt";
    httpMethod = HttpMethod.PUT;
    header[HttpHeaders.contentTypeHeader] = "text/plain";
  //  List<String> a = image.path.split("/");

    // body = package.encodeJpg(im, quality: 100);

    print("melody1");
   // Uint8List s = image.readAsBytesSync();
    print("melody2");

   // String crypted = HazizzCrypt.encrypt(base64.encode(s), key, iv); //encrypt
    print("melody3");

    body = imageData.encryptedData;

    debugPrint(body);
  }

  @override
  convertData(Response response) {
    print(response.data);
    String imgUrl = response.data;
    return imgUrl;
  }
}

class GetUploadedImage extends Request {
  GetUploadedImage({ @required String url})  {
    BASE_URL = url;
    httpMethod = HttpMethod.GET;
    authTokenHeader = false;
    contentTypeHeader = false;
  }

  @override
  convertData(Response response) {
    String encryptedImg = response.data;
    return encryptedImg;
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

  Report.group({ @required int p_groupId, @required String b_description})  {
    PATH = "groups/$p_groupId/report";
    hardCodeReducer( b_description);
  }

  Report.subject({@required int p_groupId, @required int p_subjectId, @required String b_description})  {
    PATH = "subjects/$p_subjectId/report";
    hardCodeReducer( b_description);
  }

  Report.task({ @required int p_taskId, @required String b_description})  {
    PATH = "tasks/$p_taskId/report";
    hardCodeReducer( b_description);
  }

  Report.comment({ @required int p_commentId, @required int p_taskId, @required String b_description})  {
    PATH = "comments/$p_commentId/report";
    hardCodeReducer(b_description);
  }

  Report.user({ @required int p_userId, @required String b_description})  {
    PATH = "users/$p_userId/report";
    hardCodeReducer(b_description);
  }

  @override
  convertData(Response response) {
    return response;
  }
}


class CreateGroup extends HazizzRequest {

  CreateGroup.open({ @required String b_groupName})  {
    httpMethod = HttpMethod.POST;
    PATH = "groups";
    authTokenHeader = true;
    contentTypeHeader = true;
    body["groupName"] = b_groupName;
    body["type"] = "OPEN";
  }

  CreateGroup.closed({ @required String b_groupName})  {
    httpMethod = HttpMethod.POST;
    PATH = "groups";
    authTokenHeader = true;
    contentTypeHeader = true;
    body["groupName"] = b_groupName;
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


  RetrieveGroup({ @required int p_groupId,})  {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${p_groupId}";
    authTokenHeader = true;
  }

  RetrieveGroup.details({ @required int p_groupId,})  {
    httpMethod = HttpMethod.GET;
    PATH = "groups/${p_groupId}/details";
    authTokenHeader = true;
    isDetailed = true;
  }

  RetrieveGroup.withoutMe({ @required int p_groupId,})  {
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

  LeaveGroup({@required int p_groupId})  {
    httpMethod = HttpMethod.GET;
    PATH = "users/${CacheManager.getMyIdSafely}/leavegroup/$p_groupId";
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

  JoinGroup({ @required int p_groupId,})  {
    httpMethod = HttpMethod.GET;
    PATH = "users/${CacheManager.getMyIdSafely}/joingroup/$p_groupId";
    authTokenHeader = true;
  }

  JoinGroup.withPassword({ @required int p_groupId, @required String p_password})  {
    httpMethod = HttpMethod.GET;
    PATH = "users/${CacheManager.getMyIdSafely}/joingroup/$p_groupId/$p_password";
    authTokenHeader = true;
  }

  @override
  convertData(Response response) {
    return getIterable(response.data).map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
  }
}


class PromoteMember extends HazizzRequest {

  void hardCodeReducer(int g, int u){
    httpMethod = HttpMethod.POST;
    PATH = "groups/$g/permissions/$u";
    authTokenHeader = true;
  }

  PromoteMember.toModerator({ @required int p_groupId, @required int p_userId,})  {
    hardCodeReducer(p_groupId, p_userId);
    body["permission"] = "MODERATOR";
  }

  PromoteMember.toUser({ @required int p_groupId, @required int p_userId})  {
    hardCodeReducer(p_groupId, p_userId);
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
    PATH = "users/${CacheManager.getMyIdSafely}/groups";
    authTokenHeader = true;
  }

  @override
  convertData(Response response) {
    return getIterable(response.data).map<PojoGroup>((json) => PojoGroup.fromJson(json)).toList();
  }
}

//region Subject requests
class DeleteSubject extends HazizzRequest {
  DeleteSubject({ @required int p_subjectId})  {
    httpMethod = HttpMethod.DELETE;
    PATH = "subjects/$p_subjectId";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class CreateSubject extends HazizzRequest {
  CreateSubject({ @required int p_groupId, @required String b_subjectName, @required bool b_subscriberOnly = false})  {
    httpMethod = HttpMethod.POST;
    PATH = "subjects/groups/${p_groupId}";
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
  UpdateSubject({ @required int p_subjectId, @required String b_subjectName, @required bool b_subscriberOnly = false})  {
    httpMethod = HttpMethod.PATCH;
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
  SubscribeToSubject({ @required int p_subjectId,})  {
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
  UnsubscribeFromSubject({ @required int p_subjectId,})  {
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
  GetSubjects({ int groupId})  {
    httpMethod = HttpMethod.GET;
    PATH = "subjects/groups/${groupId}";
    authTokenHeader = true;
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
  CreateTask({  int groupId, int subjectId,
    @required  List<String> b_tags, @required String b_description,
    @required DateTime b_deadline, String b_salt })  {
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
    body["description"] = b_description == null ? "" : b_description;
    body["dueDate"] = b_deadline.hazizzRequestDateFormat;
    if(b_salt != null && b_salt != ""){
      body["salt"] = b_salt;
    }
  }
  @override
  dynamic convertData(Response response) {
    var task = PojoTask.fromJson(jsonDecode(response.data));
    return task;
  }
}

class EditTask extends HazizzRequest {
  EditTask({ @required int taskId,
    @required List<String> b_tags,
    @required String b_description,@required  DateTime b_deadline, String b_salt})  {
    httpMethod = HttpMethod.PATCH;
    PATH = "tasks/${taskId}";

    authTokenHeader = true;
    contentTypeHeader = true;

    body["tags"] = b_tags;
    body["description"] = b_description;
    body["dueDate"] = b_deadline.hazizzRequestDateFormat;
    if(b_salt != null && b_salt != ""){
      body["salt"] = b_salt;
    }
  }
  @override
  dynamic convertData(Response response) {
    var task = PojoTask.fromJson(jsonDecode(response.data));
    return task;
  }
}

class DeleteTask extends HazizzRequest {
  DeleteTask({ int groupId, int subjectId, @required int taskId})  {
    httpMethod = HttpMethod.DELETE;
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
  GetTaskByTaskId({ int p_taskId})  {
    httpMethod = HttpMethod.GET;
    PATH = "tasks/${p_taskId}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoTaskDetailed task = PojoTaskDetailed.fromJson(jsonDecode(response.data));
    return task;
  }
}

class GetAlertSettings extends HazizzRequest {
  GetAlertSettings({ @required int q_userId})  {
    httpMethod = HttpMethod.GET;
    PATH = "users/$q_userId/alertsettings";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoAlertSettings alertSetting = PojoAlertSettings.fromJson(jsonDecode(response.data));
    return alertSetting;
  }
}

class UpdateAlertSettings extends HazizzRequest {
  UpdateAlertSettings({ @required int q_userId, @required String b_alarmTime,
  @required bool b_mondayEnabled, @required bool b_tuesdayEnabled, @required bool b_wednesdayEnabled,
  @required bool b_thursdayEnabled, @required bool b_fridayEnabled, @required bool b_saturdayEnabled,
  @required bool b_sundayEnabled})  {
    httpMethod = HttpMethod.POST;
    PATH = "users/$q_userId/alertsettings";
    authTokenHeader = true;

    body["alarmTime"] = b_alarmTime;
    body["mondayEnabled"] = b_mondayEnabled;
    body["tuesdayEnabled"] = b_tuesdayEnabled;
    body["wednesdayEnabled"] = b_wednesdayEnabled;
    body["thursdayEnabled"] = b_thursdayEnabled;
    body["fridayEnabled"] = b_fridayEnabled;
    body["saturdayEnabled"] = b_saturdayEnabled;
    body["sundayEnabled"] = b_sundayEnabled;
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
    PATH = "users/${CacheManager.getMyIdSafely}/notifications";
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
  GetTasksFromMe({ bool q_showThera = true,
                  bool q_unfinishedOnly, bool q_finishedOnly,
                  List<String> q_tags, String q_startingDate,
                  String q_endDate, int q_groupId,
                  int q_subjectId, q_wholeGroup = false
  })  {
    httpMethod = HttpMethod.GET;
    PATH = "users/${CacheManager.getMyIdSafely}/tasks";
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
  SetTaskCompleted({ @required int p_taskId, @required bool setCompleted})  {
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
  GetTasksFromGroup({ int groupId})  {
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
  GetTaskComments({ int p_taskId})  {
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
  CreateTaskComment({ @required int p_taskId, @required String b_content})  {
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
  DeleteComment({ @required int p_commentId})  {
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
  GetGroupMembers({ int groupId})  {
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
  GetGroupMemberPermissions({ int groupId})  {
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
  KickGroupMember({ @required int p_groupId, @required int p_userId})  {
    httpMethod = HttpMethod.DELETE;
    PATH = "groups/$p_groupId/users/$p_userId";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}



class GetGroupInviteLinks extends Request {
  GetGroupInviteLinks.open({ @required int groupId})  {
    httpMethod = HttpMethod.GET;
    PATH = "s/groups/$groupId";
    authTokenHeader = true;
  }
  GetGroupInviteLinks.closed({ @required int groupId,  @required int groupPassword})  {
    httpMethod = HttpMethod.GET;
    PATH = "s/groups/$groupId/$groupPassword";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;//response.headers.value("Location");
    /*
    Iterable iter = getIterable(response.data);
    List<PojoInviteLink> links = iter.map<PojoInviteLink>((json) => PojoInviteLink.fromJson(json)).toList();
    return links;
    */
  }
}

class RemoveGroupInviteLink extends HazizzRequest {
  RemoveGroupInviteLink({ @required int groupId, @required int inviteId})  {
    httpMethod = HttpMethod.DELETE;
    PATH = "groups/${groupId}/invitelinks/${inviteId}";
    authTokenHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

/*
class GetGroupInviteLink extends HazizzRequest {
  GetGroupInviteLink({ @required int groupId})  {
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
  KretaGetSessions()  {
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
  KretaGetProfile({ @required PojoSession session})  {
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
  KretaCreateSession({ @required String b_username, @required String b_password, @required String b_url})  {
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
  KretaRemoveSessions({ @required int p_session})  {
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
  KretaAuthenticateSession({ @required int p_session, @required String b_password})  {
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
  KretaGetNotes()  {
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
  KretaGetGrades()  {
    httpMethod = HttpMethod.GET;
    PATH = "users/${CacheManager.getMyIdSafely}/grades";
    authTokenHeader = true;
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
  KretaGetGradeAvarages()  {
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
  KretaGetSchedules({ int q_weekNumber, int q_year})  {
    httpMethod = HttpMethod.GET;
    PATH = "users/${CacheManager.getMyIdSafely}/schedules";
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
  KretaGetSchedulesWithSession({ int q_weekNumber, int q_year})  {
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
  DummyKretaGetGrades()  {
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
  DummyKretaGetSchedules()  {
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
  KretaGetSchools()  {
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