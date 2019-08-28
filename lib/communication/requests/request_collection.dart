//import 'dart:convert';
import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/pojos/PojoGroupDetailed.dart';
import 'package:mobile/communication/pojos/PojoMeInfoPrivate.dart';
import 'package:mobile/communication/pojos/PojoMeInfo.dart';
import 'package:mobile/communication/pojos/PojoSchedules.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/communication/pojos/pojo_comment.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/enums/groupTypesEnum.dart';
import 'package:mobile/managers/kreta_session_manager.dart';
import 'package:mobile/managers/token_manager.dart';
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';
//import 'package:mobile/packages/hazizz-dio-2.1.3/lib/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mobile/converters/PojoConverter.dart';


import '../../HttpMethod.dart';
import '../../hazizz_app_info.dart';
import '../../hazizz_date.dart';
import '../ResponseHandler.dart';

//region The base request
class Request {
  dynamic responseData;

  BehaviorSubject subject;

  bool authTokenHeader = false;
  bool contentTypeHeader = false;

  static const String BASE_URL = "https://hazizz.duckdns.org:9000/";
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
    print("im so done 1");
    PackageInfo p = await PackageInfo.fromPlatform();
    print("im so done 2");
    header["User-Agent"] = "HM-${p.version}";
  /*
    if(HazizzAppInfo().getInfo == null){
      PackageInfo p = await PackageInfo.fromPlatform();
      header["User-Agent"] = "HM-${p.version}";
    }else {
      header["User-Agent"] = "HM-${HazizzAppInfo().getInfo.version}";
    }
    */
    print("im so done 3");
    if(authTokenHeader){
      header[HttpHeaders.authorizationHeader] = "Bearer ${await TokenManager.getToken()}";
    }if(contentTypeHeader) {
      header[HttpHeaders.contentTypeHeader] = "application/json";
    }
    print(header);
    print("im so done 4");
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
    print("log: WARNING: convertData function not implemented");
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

class CreateTokenWithGoogleAccount extends AuthRequest{
  CreateTokenWithGoogleAccount({@required String b_openIdToken}) : super(null){
    httpMethod = HttpMethod.POST;
    PATH = "auth/googleauth";
    body["openIdToken"] = b_openIdToken;
    contentTypeHeader = true;
  }

  @override
  dynamic convertData(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    return tokens;
  }
}

class CreateTokenWithRefresh extends AuthRequest{
  CreateTokenWithRefresh({@required String b_username,@required  String b_refreshToken, ResponseHandler rh}) : super(rh){
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

  @override
  convertData(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    return tokens;
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
      print("password222: ${b_password}");
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
  CreateSubject({ResponseHandler rh, @required int p_groupId, @required String b_subjectName}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "subjects/group/${p_groupId}";
    authTokenHeader = true;
    contentTypeHeader = true;
    body["name"] = b_subjectName;
  }

  @override
  dynamic convertData(Response response) {

    var asd = PojoSubject.fromJson(jsonDecode(response.data));
    return asd;
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
    print("mamma oouuooo: ${PATH}");
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

    print(body);
    print(PATH);

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

class GetTasksFromMe extends HazizzRequest {
  GetTasksFromMe({ResponseHandler rh}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "v2/me/tasks";
    authTokenHeader = true;
  }

  @override
  void onSuccessful(Response response) {

  }

  @override
  dynamic convertData(Response response) {
    print("log: in convertData2222: ${response}");
    Iterable iter = getIterable(response.data);
    print("deebei");
    List<PojoTask> myTasks = iter.map<PojoTask>((json) => PojoTask.fromJson(json)).toList();
    myTasks.sort();
    print("log: in convertData2: ${myTasks}");

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


class GetTaskComments extends HazizzRequest {
  GetTaskComments({ResponseHandler rh, int taskId}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "tasks/${taskId}/comments";
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
    PATH = "tasks/${p_taskId}/comments";
    authTokenHeader = true;
    body["content"] = b_content;
  }

  @override
  dynamic convertData(Response response) {
    return response;
  }
}

class DeleteTaskComment extends HazizzRequest {
  DeleteTaskComment({ResponseHandler rh, @required int p_taskId, @required int p_commentId}) : super(rh) {
    httpMethod = HttpMethod.DELETE;
    PATH = "tasks/${p_taskId}/comments/$p_commentId";
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
  KretaAuthenticateSession({ResponseHandler rh, @required String p_session, @required String b_password}) : super(rh) {
    httpMethod = HttpMethod.POST;
    PATH = "kreta/sessions/${p_session}/auth";
    authTokenHeader = true;
    contentTypeHeader = true;

    body["password"] = b_password;
    print(body);

  }

  @override
  dynamic convertData(Response response) {

    PojoSession session = PojoSession.fromJson(jsonDecode(response.data));

    return session;
  }
}
//endregion

class KretaGetGrades extends TheraRequest {
  KretaGetGrades({ResponseHandler rh,}) : super(rh) {
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

class KretaGetSchedules extends TheraRequest {
  KretaGetSchedules({ResponseHandler rh, int q_weekNumber, int q_year}) : super(rh) {
    httpMethod = HttpMethod.GET;
    PATH = "v2/kreta/sessions/${KretaSessionManager.selectedSession.id}/schedule";
    authTokenHeader = true;

    if(q_weekNumber != null && q_year != null) {
      query["weekNumber"] = q_weekNumber.toString();
      query["year"] = q_year.toString();
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
    print("log: in convertData: ${response}");
    PojoGrades pojoGrades = PojoGrades.fromJson(jsonDecode(response.data));

    print("log: in convertData: pojoGrades: ${pojoGrades.grades}");

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