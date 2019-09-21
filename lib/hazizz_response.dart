import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
//import 'package:mobile/packages/hazizz-dio-2.1.3/lib/dio.dart';
//import 'package:mobile/packages/hazizz-dio-2.1.3/lib/dio.dart';

//import 'package:dio/dio.dart';

import 'blocs/kreta_status_bloc.dart';
import 'blocs/selected_session_bloc.dart';
import 'custom/hazizz_logger.dart';
import 'logger.dart';
import 'managers/app_state_manager.dart';
import 'request_sender.dart';
import 'communication/ResponseHandler.dart';
import 'communication/pojos/PojoError.dart';
import 'communication/pojos/PojoTokens.dart';
import 'communication/requests/request_collection.dart';
import 'managers/token_manager.dart';
import 'managers/cache_manager.dart';

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
    HazizzLogger.printLog("HazizzLog: response conversion was successful");
    hazizzResponse.isSuccessful = true;

    HazizzLogger.printLog("HazizzLog: successful response raw body: ${response.data}");


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
    HazizzLogger.printLog("HazizzLog: error response raw body: ${hazizzResponse.response.data}");
    HazizzLogger.printLog("HazizzLog: error response dio error: ${hazizzResponse.dioError.type.toString()}");


    return hazizzResponse;
  }

  onErrorResponse()async {
    if(response != null) {
      HazizzLogger.printLog("log: error response: $response");

      pojoError = PojoError.fromJson(json.decode(response?.data));

      if(pojoError != null){
        hasPojoError = true;
        if(pojoError.errorCode == 138){
          KretaStatusBloc().dispatch(KretaStatusUnavailableEvent());
        }
        else if(pojoError.errorCode == 19) { // to many requests
          HazizzLogger.printLog("HazizzLog: To many requests");
          await RequestSender().waitCooldown();
        }
        else if(pojoError.errorCode == 18 ||
            pojoError.errorCode == 17) { // wrong token
          // a requestet elmenteni hogy újra küldje
          HazizzLogger.printLog("HazizzLog: token is wrong or expired, the failed request is saved and a refrest token request is being sent. dio interceptro: ${RequestSender().isLocked()}");
          if(!RequestSender().isLocked()) {
            RequestSender().lock();

            HazizzResponse tokenResponse = await TokenManager.createTokenWithRefresh();

            if(tokenResponse.isSuccessful) {
              RequestSender().unlock();
            }else if(tokenResponse.pojoError != null){
              if(tokenResponse.pojoError.errorCode == 17){
                AppState.logout();
              }

              HazizzLogger.printLog("HazizzLog: obtaining token failed. The user is redirected to the login screen");

            }


            // elküldi újra ezt a requestet ami errort dobott
            HazizzResponse hazizzResponse = await RequestSender().getResponse(request);
            HazizzLogger.printLog("HazizzLog: resent failed request)");

            RequestSender().unlock();

          }else {
            RequestSender().getResponse(request);
          }
        }else if(pojoError.errorCode == 13 || pojoError.errorCode == 14 ||
            pojoError.errorCode == 15) {
          // navigate to login/register page
        }else if(pojoError.errorCode == 136 || pojoError.errorCode == 132 || pojoError.errorCode == 130){
          SelectedSessionBloc().dispatch(SelectedSessionInactiveEvent());
        }
        HazizzLogger.printLog("log: response error: ${pojoError.toString()}");
        // throw new HResponseError(pojoError);
        //  return pojoError;
        //request.onError(pojoError);
      }
      else{
        if(dioError.type == DioErrorType.CONNECT_TIMEOUT){
          dioError.response.headers.contentType.toString();
        }
      }
    }
  }
}