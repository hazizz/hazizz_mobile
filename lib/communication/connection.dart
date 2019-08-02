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
        listeners.forEach((k,v) => v());


        listeners.clear();


      } else {
        // hasConnection = false;
        print("log: connection: not available");

        //  lock();
      }
    });
  }

  static Map<String, Function> listeners = Map();

  static void addConnectionOnlineListener(Function listener, String identifier){
    print("log: about to add listener: ${identifier}");

  //  listeners.
    listeners[identifier] = listener;
  //  listeners.add(listener);
    print("log: added listener: ${listeners}");

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