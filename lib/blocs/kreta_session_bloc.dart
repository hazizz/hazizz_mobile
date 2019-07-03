
import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errorcode_collection.dart';
import 'package:mobile/communication/pojos/PojoError.dart';
import 'package:mobile/communication/pojos/PojoTokens.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RequestSender.dart';
import '../hazizz_response.dart';

class LoginError implements Exception{

}

class WrongUsernameException implements LoginError{
  @override
  String toString() => "WrongUsernameException";
}

class WrongPasswordException implements LoginError{
  @override
  String toString() => "WrongUsernameException";
}



class KretaSessionEvent extends HEvent{
  KretaSessionEvent([List props = const []]) : super(props);
}
class KretaSessionState extends HState{
  KretaSessionState([List props = const []]) : super(props);
}

class KretaSessionCreateSessionEvent extends KretaSessionEvent{

  final String username;
  final String password;
  final String url;

  KretaSessionCreateSessionEvent({
    @required this.username,
    @required this.password,
    @required this.url
  }) : super([username, password, url]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password, url: $url }';
}



class KretaSessionBloc extends Bloc<HEvent, HState> {









  static final String _keyToken = "key_token";
  static final String _keyRefreshToken = "key_refreshToken";
  static bool tokenIsValid = true;

  SharedPreferences prefs;

  static Future<bool> hasToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_keyToken);
    return !(token == null || token == "");
  }



  static Future<String> getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> fetchTokens(@required String username, @required String password) async{
    print("asdsadsadsaASADA");
    HazizzResponse hazizzResponse = await RequestSender().getResponse(new CreateTokenWithPassword(b_username: username, b_password: password));
    if(hazizzResponse.isSuccessful){
      print("log: token: tokens set");
      PojoTokens tokens = hazizzResponse.convertedData;
      InfoCache.setMyUsername(username);
      setToken(tokens.token);
      setRefreshToken(tokens.refresh);
    }else if(hazizzResponse.hasPojoError){
      int errorCode = hazizzResponse.pojoError.errorCode;
      print("log: errorCode: $errorCode");
      if(ErrorCodes.INVALID_PASSWORD.equals(errorCode)){
        throw new WrongPasswordException();
      }else if(ErrorCodes.USER_NOT_FOUND.equals(errorCode)){
        throw new WrongUsernameException();
      }
    }
    print("log: fetch token: done");
  }

  static Future<void> fetchRefreshTokens(@required String username, @required String refreshToken) async{
    HazizzResponse hazizzResponse = await RequestSender().getResponse(new CreateTokenWithRefresh(b_username: username, b_refreshToken: refreshToken));
    if(hazizzResponse.isSuccessful){
      PojoTokens tokens = hazizzResponse.convertedData;
      InfoCache.setMyUsername(username);
      setToken(tokens.token);
      setRefreshToken(tokens.refresh);
    }else if(hazizzResponse.hasPojoError){
      int errorCode = hazizzResponse.pojoError.errorCode;
      if(ErrorCodes.INVALID_PASSWORD.equals(errorCode)){
        throw WrongPasswordException;
      }else if(ErrorCodes.USER_NOT_FOUND.equals(errorCode)){
        throw WrongUsernameException();
      }
    }
  }

  static Future<String> getRefreshToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  static void setToken(String newToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyToken, newToken);
  }

  static void setRefreshToken(String newRefreshToken) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyRefreshToken, newRefreshToken);
  }

  static Future<bool> hasRefreshToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String refreshToken = prefs.getString(_keyRefreshToken);
    return !(refreshToken == null || refreshToken == "");
  }

  static void invalidateTokens() {
    setRefreshToken("");
    setToken("");
    tokenIsValid = false;
  }

  static bool tokenInvalidated() {
    return !tokenIsValid;
  }

  @override
  // TODO: implement initialState
  HState get initialState => null;

  @override
  Stream<HState> mapEventToState(HEvent event) {
    // TODO: implement mapEventToState
    return null;
  }
}