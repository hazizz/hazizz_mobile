// EZT NÉZD MEG -->https://github.com/Solido/awesome-flutter
import 'package:dio/dio.dart';
import 'Request.dart';
import 'dart:collection';
import 'HttpMethod.dart';
import 'RequestSender.dart';
import 'communication/pojos/PojoError.dart';
import 'CreateTokenWithPassword.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';

class RequestSender{

  static bool firstMet = true;

  static final RequestSender _instance = new RequestSender._internal();

  factory RequestSender() {
    return _instance;
  }



  RequestSender._internal(){
   /* if(firstMet){
      firstMet = false;
      */
     // print("RequestSender: is null");
      dio.interceptors.add(InterceptorsWrapper(
          onRequest:(RequestOptions options){
            // Do something before request is sent
            /*
            dio.interceptors.requestLock.lock();
            dio.clear();
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
            PojoError pojoError = PojoError.fromJson(jsonDecode(e.response.data));
            print("log: errorCode: ${pojoError.errorCode}");
            print("log: message: ${pojoError.message}");



            try{
            }catch(DioError){

            }
           // return  e;//continue
          }
      ));
   // }
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
      responseType: ResponseType.json,
      receiveDataWhenStatusError: true,
      followRedirects: true);

  static final Dio dio = new Dio();

  void asd(){
    print("azta");
  }


  Future<Response> send(Request request) async{
   // Options options = options2;
    Response response;
    if(request.httpMethod == HttpMethod.GET) {
      options.headers = request.header;


      response = await dio.get(request.url, options: options);

    }else if(request.httpMethod == HttpMethod.POST) {
      options.headers = request.header;

     // response = await dio.post(request.url, data: request.body, options: options);
      try{
        response = await dio.post(request.url, data: request.body, options: options);
      }on DioError catch(error){
        if(error.response.statusCode == 400 || error.response.statusCode == 401 ||
            error.response.statusCode == 402 || error.response.statusCode == 403 ||
            error.response.statusCode == 404
        ){
          print("log: error response data: ${error.response.data}");
          //  request.rh.onResponse();
        }
      }


    }else if(request.httpMethod == HttpMethod.DELETE) {
      options.headers = request.header;

      response = await dio.delete(request.url, data: request.body, options: options);
    }

    /*
    if(response.statusCode == 200 || response.statusCode == 201 ||
       response.statusCode == 202 || response.statusCode == 203 ||
       response.statusCode == 204
      ){
      request.rh.onResponse(response);
    }else if(response.statusCode == 400 || response.statusCode == 401 ||
        response.statusCode == 402 || response.statusCode == 403 ||
        response.statusCode == 404
    ){
      print("log: error response data: ${response.data}");
    //  request.rh.onResponse();
    }
    */
    print("reached");
   // print("log: error response data: ${response.data}");



    return response;


  }
}