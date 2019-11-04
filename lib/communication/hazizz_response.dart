import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:mobile/blocs/flush_bloc.dart';
import 'package:mobile/blocs/kreta/kreta_status_bloc.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/kreta/sessions_bloc.dart' as prefix0;
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/custom_exception.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/token_manager.dart';

import 'custom_response_errors.dart';
//import 'package:mobile/packages/hazizz-dio-2.1.3/lib/dio.dart';
//import 'package:mobile/packages/hazizz-dio-2.1.3/lib/dio.dart';

//import 'package:dio/dio.dart';

class HazizzResponse{

  bool isSuccessful = false;
  bool isError = false;
  bool hasPojoError = false;

  Request request;

  Response response;

 // Function convertData;

  dynamic convertedData;

  DioError dioError;

  PojoError pojoError;

  HazizzResponse._();

  static HazizzResponse onSuccess({@required Response response, @required Request request}){
    HazizzResponse hazizzResponse = new HazizzResponse._();
    hazizzResponse.response = response;
    hazizzResponse.request = request;
    hazizzResponse.convertedData = request.convertData(response);
    HazizzLogger.printLog("response conversion was successful");
    hazizzResponse.isSuccessful = true;

    if(request is AuthRequest){
      HazizzLogger.printLog("successful token response");

    }else {
      HazizzLogger.printLog("successful response raw body: ${response.data}");
    }

    if(request is TheraRequest && KretaStatusBloc().currentState is KretaStatusUnavailableState){
      KretaStatusBloc().dispatch(KretaStatusAvailableEvent());
    }

    return hazizzResponse;
  }

  static Future<HazizzResponse> onError({@required DioError dioError, @required Request request})async{
  //  _onErrorResponse(dioError);
    HazizzResponse hazizzResponse = new HazizzResponse._();
    hazizzResponse.dioError = dioError;
    hazizzResponse.response = dioError.response;
    hazizzResponse.request = request;
    hazizzResponse.isError = true;
    await hazizzResponse.onErrorResponse();
    if(request is CreateToken){
      HazizzLogger.printLog("error obtaining token response. Big problem");
    }else {
      HazizzLogger.printLog("error response raw body: ${hazizzResponse.response.data}");
    }
    HazizzLogger.printLog("error response dio error: ${hazizzResponse.dioError.type.toString()}");


    return hazizzResponse;
  }

  onErrorResponse()async {
    if(response != null) {
      pojoError = PojoError.fromJson(json.decode(response?.data));

      HazizzLogger.printLog("log: error response: $response");

      if(pojoError != null){
        hasPojoError = true;
        if(pojoError.errorCode == 1){
          Crashlytics().recordError(CustomException(pojoError.toJson().toString()), StackTrace.current);
        }
        else if(pojoError.errorCode == 138){
          KretaStatusBloc().dispatch(KretaStatusUnavailableEvent());
          flushBloc.dispatch(FlushKretaUnavailableEvent());
        }
        else if(pojoError.errorCode == 19) { // to many requests
          HazizzLogger.printLog("Too many requests");
          await RequestSender().waitCooldown();

        }
        else if(pojoError.errorCode == 18 ||
                pojoError.errorCode == 17) { // wrong token
          // a requestet elmenteni hogy újra küldje
          HazizzLogger.printLog("token is wrong or expired, the failed request is saved and a refresh token request is being sent. dio interceptro: ${RequestSender().isLocked()}");
          if(!RequestSender().isLocked()) {
            HazizzLogger.printLog("Locking dio interceptor and sending refresh token request");

            RequestSender().lock();

            HazizzResponse tokenResponse = await TokenManager.createTokenWithRefresh();

            if(tokenResponse.isSuccessful) {
              RequestSender().unlockTokenRefreshRequests();
            }else{
              if(tokenResponse.pojoError != null && tokenResponse.pojoError.errorCode == 17){
                await AppState.logout();
                return;
              }
              HazizzLogger.printLog("obtaining token failed. The user is redirected to the login screen");
            }
            // elküldi újra ezt a requestet ami errort dobott
            RequestSender().refreshRequestQueue.add(request);
        //    HazizzResponse hazizzResponse = await RequestSender().getResponse(await refreshTokenInRequest(request));
            HazizzLogger.printLog("added request to refreshtoken list: ${request}");

           // RequestSender().unlockTokenRefreshRequests();
          }else {
            HazizzLogger.printLog("Still waiting for refresh token request response, saving the new request in the queue");

            RequestSender().refreshRequestQueue.add(request);
           // RequestSender().getResponse(request);
          }
        }else if(pojoError.errorCode == 13 || pojoError.errorCode == 14 ||
            pojoError.errorCode == 15) {
          // navigate to login/register page
        }else if(pojoError.errorCode == 132 && !(request is KretaAuthenticateSession)){
         // SelectedSessionBloc().dispatch(SelectedSessionSetEvent(null));
          Crashlytics().recordError(CustomException("Tried authenticating a non existing session"), StackTrace.current, context: "Session is null");
          // TODO handle this
          HazizzResponse hazizzResponse = await RequestSender().getResponse(KretaCreateSession(b_username: SelectedSessionBloc().selectedSession.username, b_password: SelectedSessionBloc().selectedSession.password, b_url: SelectedSessionBloc().selectedSession.url));
          if(hazizzResponse.isSuccessful){
            PojoSession newSession = hazizzResponse.convertedData;
            SelectedSessionBloc().dispatch(SelectedSessionSetEvent(newSession));
          }else{
            Crashlytics().recordError(CustomException("Session creation failed. ErrorCode: ${pojoError?.errorCode}"), StackTrace.current, context: "Session creation failed");
            SelectedSessionBloc().dispatch(SelectedSessionInactiveEvent());
          }
        }
        // TODO ^ massive rework needed
        else if(pojoError.errorCode == 136 || pojoError.errorCode == 132 || pojoError.errorCode == 130){
          SelectedSessionBloc().dispatch(SelectedSessionInactiveEvent());
        }
        HazizzLogger.printLog("log: response error: ${pojoError.toString()}");
      }
      else{
        if(dioError.type == DioErrorType.CONNECT_TIMEOUT){
          dioError.response.headers.contentType.toString();
        }
      }
    }else{
      if(dioError == noConnectionError){
        print("No connection error fired");
        flushBloc.dispatch(FlushNoConnectionEvent());
      }
    }
  }
}