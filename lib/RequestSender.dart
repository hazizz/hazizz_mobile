// EZT NÉZD MEG -->https://github.com/Solido/awesome-flutter
import 'dart:async';

import 'package:dio/dio.dart';
import 'HttpMethod.dart';
import 'communication/ResponseHandler.dart';
import 'communication/pojos/PojoError.dart';
import 'dart:convert';

import 'communication/pojos/PojoTokens.dart';
import 'communication/requests/request_collection.dart';
import 'managers/TokenManager.dart';
import 'managers/cache_manager.dart';
import 'package:connectivity/connectivity.dart';

class RequestSender{
  static final RequestSender _instance = new RequestSender._internal();
  
  bool _isLocked = false;

  factory RequestSender() {
    return _instance;
  }

  static StreamSubscription streamConnectionStatus;
  static ConnectivityResult connectivity;
  static bool hasConnection;
  Future<Null> getConnectionStatus() async {
    streamConnectionStatus = new Connectivity()
    .onConnectivityChanged
    .listen((ConnectivityResult result) {
      print(result.toString());
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
         // hasConnection = true;
        print("log: connection: available");
        unlock();
      } else {
         // hasConnection = false;
        print("log: connection: not available");

        lock();
      }
    });
  }

  /*
  // dispose function inside class
  @override
  void dispose() {
    try {
      streamConnectionStatus?.cancel();
    } catch (exception, stackTrace) {
      print(exception.toString());
    } finally {
      super.dispose();
    }
  }
  */

  RequestSender._internal(){
    getConnectionStatus();

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
        print("log: got response");
        return response; // continue
      },
      onError: (DioError e) async{
        print("log: got error");

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
      connectTimeout: 5000,
      sendTimeout: 5000,
      receiveTimeout: 5000,
    //  headers: request.header,
      responseType: ResponseType.plain,
      receiveDataWhenStatusError: true,
      followRedirects: true);

  static final Dio dio = new Dio();

  void stop() async{
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
  Future<Response> tokenRequestSend(AuthRequest authRequest) async{
    try{
      options.headers = await authRequest.buildHeader();
      Dio authDio = Dio();
      Response response = await authDio.post(authRequest.url, data: authRequest.body, options: options);
      authRequest.onSuccessful(response);
      print("hey: sent token request");
    }on DioError catch(error){
     // PojoError pojoError = PojoError.fromJson(json.decode(error.response?.data));
      print("log: error response data: ${error.response.data}");
    }
  }

  Future<Response> send(Request request) async{
    Response response;
    try {
      if (request.httpMethod == HttpMethod.GET) {
        options.headers = await request.buildHeader();
        response = await dio.get(request.url, options: options);
      }else if (request.httpMethod == HttpMethod.POST) {
        options.headers = await request.buildHeader();
        response =
        await dio.post(request.url, data: request.body, options: options);
      }else if (request.httpMethod == HttpMethod.DELETE) {
        options.headers = await request.buildHeader();
        response =
        await dio.delete(request.url, data: request.body, options: options);
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
                    onSuccessful: (Response response) {
                      print("hey: got token reponse");
                      PojoTokens pojoTokens = PojoTokens.fromJson(jsonDecode(response.data));
                      TokenManager.setToken(pojoTokens.token);
                      TokenManager.setRefreshToken(pojoTokens.refresh);
                      print("hey: got token reponse: ${pojoTokens.token}");
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
}