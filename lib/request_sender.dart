// EZT NÉZD MEG -->https://github.com/Solido/awesome-flutter
import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
//import 'package:mobile/packages/hazizz-dio-2.1.3/lib/dio.dart';
import 'HttpMethod.dart';

import 'communication/connection.dart';
import 'communication/errors.dart';
import 'communication/requests/request_collection.dart';
import 'hazizz_response.dart';

Future<HazizzResponse> getResponse(Request request)async{
  return await RequestSender().getResponse(request);
}

class RequestSender{
  static final RequestSender _instance = new RequestSender._internal();
  
  bool _isLocked = false;

  factory RequestSender() {
    return _instance;
  }

  RequestSender._internal(){

    dio.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options) async{
        // Do something before request is sent
        /*
        dio.interceptors.requestLock.lock();
        dio.clear();
        */
        /*
        connectivity = await Connectivity().checkConnectivity();
        if(!(connectivity == ConnectivityResult.wifi ||connectivity == ConnectivityResult.mobile)){
          dio.lock();
        }
        */
        print("log: sent request");
        return options; //continue
        // If you want to resolve the request with some custom data，
        // you can return a `Response` object or return `dio.resolve(data)`.
        // If you want to reject the request with a error message,
        // you can return a `DioError` object or return `dio.reject(errMsg)`
      },
      onResponse:(Response response) {
        // Do something with response data
        print("log: got response: ${response.data}");

        return response; // continue
      },
      onError: (DioError e) async{
        print("log: got error: ${e}");

        // Do something with response error
       // return  e;//continue
      }
    ));
  }
  /*
      String method,
      int connectTimeout,
      int sendTimeout,
      int receiveTimeout,
      Iterable<Cookie> cookies,
      Map<String, dynamic> extra,
      Map<String, dynamic> headers,
      ResponseType responseType,
      ContentType contentType,
      ValidateStatus validateStatus,
      bool receiveDataWhenStatusError,
      bool followRedirects,
      int maxRedirects,
  */
  final Options options = new Options(
    /*
    responseDecoder: (List<int> responseBytes, RequestOptions options, ResponseBody responseBody){
      responseBody.
    },
    */
    connectTimeout: 7000,
    sendTimeout: 7000,
    receiveTimeout: 7000,
  //  headers: request.header,
    responseType: ResponseType.plain,
    receiveDataWhenStatusError: true,
    followRedirects: true,


  );

  static final Dio dio = new Dio();

  Future<void> waitCooldown() async{
    dio.interceptors.requestLock.lock();
    print("logtest: locked");
    await new Future.delayed(const Duration(milliseconds: 1000));
    dio.interceptors.requestLock.unlock();
  }
  void lock(){
    dio.lock();
    _isLocked = true;
  }
  void unlock(){
    dio.unlock();
    _isLocked = false;
  }
  bool isLocked(){
    return _isLocked;
  }
  Future<HazizzResponse> getTokenResponse(AuthRequest authRequest) async{
    HazizzResponse hazizzResponse;
    try{
      options.headers = await authRequest.buildHeader();
      Dio authDio = Dio();
      Response response = await authDio.post(authRequest.url, data: authRequest.body, options: options);
      hazizzResponse = HazizzResponse.onSuccess(response: response, request: authRequest);

      print("hey: sent token request");
    }on DioError catch(error){
      if(error.response != null) {
        print("log: error response data: ${error.response.data}");
      }
      hazizzResponse = await HazizzResponse.onError(dioError: error, request: authRequest);
      print(hazizzResponse);
    }
    return hazizzResponse;
  }

  /*
  Future<void> onPojoError2(PojoError pojoError, Request request) async{
    if (true) {
      // print("log: error response data: ${error.response.data}");
      // PojoError pojoError = PojoError.fromJson(json.decode(error.response?.data));

      if(pojoError.errorCode == 19){// to many requests
        print("here iam");
        stop();
      }
      else if(pojoError.errorCode == 18 || pojoError.errorCode == 17){// wrong token
        // a requestet elmenteni hogy újra küldje
        print("hey: Locked: ${isLocked()}");
        if(!isLocked()) {
          lock();
          // elküldi újra ezt a requestet ami errort dobott
          send(request);
          print("hey2: username: ${await InfoCache.getMyUsername()}");
          print("hey2: token: ${await TokenManager.getRefreshToken()}");

          await tokenRequestSend(new CreateTokenWithRefresh(
              b_username: await InfoCache.getMyUsername(),
              b_refreshToken: await TokenManager.getRefreshToken(),
              rh: ResponseHandler(
                  onSuccessful: (dynamic data) {
                    print("hey: got token reponse: ${data.token}");
                    unlock();
                  },
                  onError: (PojoError pojoError) {
                    unlock();

                  }
              )
          ));
        }else{
          send(request);
        }
        //  request.rh.onSuccessful();
      }else if(pojoError.errorCode == 13 || pojoError.errorCode == 14
          || pojoError.errorCode == 15){
        // navigate to login/register page
      }
      https://github.com/hazizz/hazizz-mobile
      print("log: response error: ${pojoError.toString()}");
      //  throw new HResponseError(pojoError);
      return pojoError;
      //  return pojoError;
      request.onError(pojoError);
    }

    //  return error.response;
  }
  */


  Set<Request> noConnectionRequestsPrioritized = Set();
  List<Request> noConnectionRequests = List();

  void addToNoConnectionRequestList(Request newRequest){

    if(newRequest is CreateTokenWithRefresh){
      noConnectionRequestsPrioritized.add(newRequest);
    }

    if(noConnectionRequests.isNotEmpty){
      for(int i = 0; i < noConnectionRequests.length; i++){
        if(noConnectionRequests[i] == newRequest){
          noConnectionRequests[i] = newRequest;
        }
      }
    }else{
      noConnectionRequests.add(newRequest);
    }
  }

  Future sendNoConnectionRequests() async {
    for(Request request in noConnectionRequestsPrioritized){
      await RequestSender().getResponse(request);
    }


  }


  Future<HazizzResponse> getResponse(Request request) async{

    HazizzResponse hazizzResponse;

  //  hazizzResponse.request = request;

    Response response;
    print("log: about to start sending request");
    bool isConnected = await Connection.isOnline();
    try {
      if(isConnected) {
        if(request.httpMethod == HttpMethod.GET) {
          options.headers = await request.buildHeader();
          response = await dio.get(request.url, queryParameters: request.query, options: options);

        }else if(request.httpMethod == HttpMethod.POST) {
          options.headers = await request.buildHeader();
          response = await dio.post(request.url, queryParameters: request.query, data: request.body, options: options);
        }else if(request.httpMethod == HttpMethod.DELETE) {
          options.headers = await request.buildHeader();
          response = await dio.delete(request.url, queryParameters: request.query, data: request.body, options: options);
        }
        hazizzResponse = HazizzResponse.onSuccess(response: response, request: request);
        print("log: request sent: ${request.toString()}");
      }else{
        throw noConnectionError;
      }
    }on DioError catch(error) {
      print("log: error damn");
      hazizzResponse = await HazizzResponse.onError(dioError: error, request: request);
    }
    return hazizzResponse;
  }


  /*
  Future<void> onPojoError2(PojoError pojoError, Request request) async{
    if (true) {
     // print("log: error response data: ${error.response.data}");
     // PojoError pojoError = PojoError.fromJson(json.decode(error.response?.data));

      if(pojoError.errorCode == 19){// to many requests
        print("here iam");
        stop();
      }
      else if(pojoError.errorCode == 18 || pojoError.errorCode == 17){// wrong token
        // a requestet elmenteni hogy újra küldje
        print("hey: Locked: ${isLocked()}");
      if(!isLocked()) {
          lock();
          // elküldi újra ezt a requestet ami errort dobott
          send(request);
          print("hey2: username: ${await InfoCache.getMyUsername()}");
          print("hey2: token: ${await TokenManager.getRefreshToken()}");

          await tokenRequestSend(new CreateTokenWithRefresh(
            b_username: await InfoCache.getMyUsername(),
            b_refreshToken: await TokenManager.getRefreshToken(),
            rh: ResponseHandler(
              onSuccessful: (dynamic data) {
                print("hey: got token reponse: ${data.token}");
                unlock();
              },
              onError: (PojoError pojoError) {
                unlock();

              }
            )
          ));
    }else{
      send(request);
    }
    //  request.rh.onSuccessful();
    }else if(pojoError.errorCode == 13 || pojoError.errorCode == 14
    || pojoError.errorCode == 15){
    // navigate to login/register page
    }
    https://github.com/hazizz/hazizz-mobile
    print("log: response error: ${pojoError.toString()}");
  //  throw new HResponseError(pojoError);
    return pojoError;
    //  return pojoError;
    request.onError(pojoError);
  }

  //  return error.response;
  }

  Future<Response> send2(Request request) async{
    Response response;
    try {
      if (request.httpMethod == HttpMethod.GET) {
        options.headers = await request.buildHeader();
        response = await dio.get(request.url, queryParameters: request.query, options: options);
      }else if (request.httpMethod == HttpMethod.POST) {
        options.headers = await request.buildHeader();
        response =
        await dio.post(request.url, queryParameters: request.query, data: request.body, options: options);
      }else if (request.httpMethod == HttpMethod.DELETE) {
        options.headers = await request.buildHeader();
        response =
        await dio.delete(request.url, queryParameters: request.query, data: request.body, options: options);
      }
    }on DioError catch(error){

      if (error.response != null) {
        print("log: error response data: ${error.response.data}");
        PojoError pojoError = PojoError.fromJson(json.decode(error.response?.data));

        if(pojoError.errorCode == 19){// to many requests
          print("here iam");
          stop();
        }
        else if(pojoError.errorCode == 18 || pojoError.errorCode == 17){// wrong token
          // a requestet elmenteni hogy újra küldje
          print("hey: Locked: ${isLocked()}");
          if(!isLocked()) {
            lock();
            // elküldi újra ezt a requestet ami errort dobott
            send(request);
            print("hey2: username: ${await InfoCache.getMyUsername()}");
            print("hey2: token: ${await TokenManager.getRefreshToken()}");

            await tokenRequestSend(new CreateTokenWithRefresh(
                b_username: await InfoCache.getMyUsername(),
                b_refreshToken: await TokenManager.getRefreshToken(),
                rh: ResponseHandler(
                    onSuccessful: (dynamic data) {
                      print("hey: got token reponse: ${data.token}");
                      unlock();
                    },
                    onError: (PojoError pojoError) {
                      unlock();
                    }
                )
            ));
          }else{
            send(request);
          }
          //  request.rh.onSuccessful();
        }else if(pojoError.errorCode == 13 || pojoError.errorCode == 14
                || pojoError.errorCode == 15){
          // navigate to login/register page
        }
        https://github.com/hazizz/hazizz-mobile
        request.onError(pojoError);
      }
      return error.response;
    }
    request.onSuccessful(response);

    print("reached");
   // print("log: error response data: ${response.data}");
    return response;
  }
  */
}