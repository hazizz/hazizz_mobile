import 'package:mobile/blocs/flush_bloc.dart';
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/communication/pojos/PojoTheraHealth.dart';
import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';

class ServerChecker{

  static bool gatewayOnline = false;
  static bool authOnline = false;
  static bool hazizzOnline = false;
  static bool theraOnline = false;

  static int kretaRequestsInLastHour;
  static double kretaSuccessRate;

  static Future<void> checkAll({bool notifyFlush = true}) async {
    if(await checkGateway(notifyFlush: notifyFlush)){
      await checkAuth(notifyFlush: notifyFlush);
      await checkHazizz(notifyFlush: notifyFlush);
      await checkThera(notifyFlush: notifyFlush);
    }else{
      authOnline = false;
      hazizzOnline = false;
      theraOnline = false;
    }
  }

  static Future<bool> checkGateway({bool notifyFlush = true}) async {
    HazizzResponse hazizzResponse = await getResponse(PingGatewayServer());
    if(hazizzResponse != null && hazizzResponse.isSuccessful){
      gatewayOnline = true;
    }else{
      if(notifyFlush) FlushBloc().add(FlushGatewayServerUnavailableEvent());
      gatewayOnline = false;
    }
    return gatewayOnline;
  }

  static Future<bool> checkAuth({bool notifyFlush = true}) async {
    HazizzResponse hazizzResponse = await getResponse(PingAuthServer());
    if(hazizzResponse != null && hazizzResponse.isSuccessful){
      authOnline = true;

    }else{
      if(notifyFlush) FlushBloc().add(FlushAuthServerUnavailableEvent());
      authOnline =  false;
    }
    return authOnline;
  }
  static Future<bool> checkHazizz({bool notifyFlush = true}) async {
    HazizzResponse hazizzResponse = await getResponse(PingHazizzServer());
    if(hazizzResponse != null && hazizzResponse.isSuccessful){
      hazizzOnline = true;

    }else{
      if(notifyFlush) FlushBloc().add(FlushHazizzServerUnavailableEvent());
      hazizzOnline = false;
    }
    return hazizzOnline;
  }
  static Future<bool> checkThera({bool notifyFlush = true}) async {
    HazizzResponse hazizzResponse = await getResponse(PingTheraServer());
    if(hazizzResponse != null && hazizzResponse.isSuccessful){
      PojoTheraHealth theraHealth = hazizzResponse.convertedData;

      if(theraHealth.status == "UP"){
        theraOnline = true;
        print("asdds1: ${theraHealth.details.theraHealthManager.details.kretaSuccessRate}");
        print("asdds2: ${theraHealth.details.theraHealthManager.details.kretaRequestsInLastHour}");

        kretaSuccessRate = theraHealth.details.theraHealthManager.details.kretaSuccessRate;
        kretaRequestsInLastHour = theraHealth.details.theraHealthManager.details.kretaRequestsInLastHour;

      }


    }else{
      if(notifyFlush) FlushBloc().add(FlushTheraServerUnavailableEvent());
      theraOnline = false;
    }
    return theraOnline;
  }
}