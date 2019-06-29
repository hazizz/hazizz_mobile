import 'package:dio/dio.dart';

import 'RequestSender.dart';

class HazizzResponse{

  Response response;

  dynamic convertedData;

  HazizzResponse(this.response, Function(Response) convert){

  }

  @override
  dynamic convertData(Response response) {
    PojoTokens tokens = PojoTokens.fromJson(jsonDecode(response.data));
    return tokens;
  }

  static onErrorResponse(DioError error)async{
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
    RequestSender().unlock();
    },
    onError: (PojoError pojoError) {
      RequestSender().unlock();

    }
    )
    ));
    }else{
          RequestSender().send(request);
    }
    //  request.rh.onSuccessful();
    }else if(pojoError.errorCode == 13 || pojoError.errorCode == 14
    || pojoError.errorCode == 15){
    // navigate to login/register page
    }
    https://github.com/hazizz/hazizz-mobile
    print("log: response error: ${pojoError.toString()}");
    throw new HResponseError(pojoError);
    //  return pojoError;
    request.onError(pojoError);
  }



}