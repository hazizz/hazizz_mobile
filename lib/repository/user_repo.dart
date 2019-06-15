import 'package:hazizz_mobile/blocs/group_bloc.dart';
import 'package:hazizz_mobile/communication/errorcode_collection.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:hazizz_mobile/communication/pojos/PojoTokens.dart';
import 'package:hazizz_mobile/communication/requests/request_collection.dart';
import 'package:hazizz_mobile/managers/TokenManager.dart';
import 'package:meta/meta.dart';

import '../RequestSender.dart';

class UserRepository {

  //<editor-fold desc="Authenticaton">
  Future<bool> authenticate({
    @required String username,
    @required String password,
  }) async {
    dynamic responseData = await RequestSender().getResponse(new CreateTokenWithPassword(b_username: username, b_password: password));
    if(responseData is PojoTokens){
      TokenManager.setToken(responseData.token);
      TokenManager.setRefreshToken(responseData.refresh);
      return true;
    }else if(responseData is PojoError){
      int errorCode = responseData.errorCode;
      if(ErrorCodes.INVALID_PASSWORD.equals(errorCode)){

      }
    }
    }


  Future<void> deleteToken() async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
//</editor-fold>






}