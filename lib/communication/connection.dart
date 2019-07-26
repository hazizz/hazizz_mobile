import 'dart:async';

import 'package:connectivity/connectivity.dart';

class Connection{

  static StreamSubscription streamConnectionStatus;
  static ConnectivityResult connectivity;

  static Future<Null> listener() async {
    streamConnectionStatus = new Connectivity()
        .onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        // hasConnection = true;
        print("log: connection: available");
        for(Function f in listeners){
          f();
        }
        listeners.clear();


      } else {
        // hasConnection = false;
        print("log: connection: not available");

        //  lock();
      }
    });
  }

  static List<Function> listeners = List();

  static void addConnectionOnlineListener(Function listener){
    listeners.add(listener);
  }


  static Future<bool> isOnline() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile) {
      return true;
    }else if(connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<bool> isOffline() async{
    return !(await isOnline());
  }



}