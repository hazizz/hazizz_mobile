import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile/notification/notification.dart';

class HazizzMessageHandler{

  static final HazizzMessageHandler _singleton = new HazizzMessageHandler._internal();
  factory HazizzMessageHandler() {
    return _singleton;
  }
  HazizzMessageHandler._internal();

  Future<String> get token async{
    return _firebaseMessaging.getToken();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> processMessage(Map<String, dynamic> message) async {
    print("Hazizz message: $message");
   // await HazizzNotification.showNotif(message["notification"]["title"], message["notification"]["body"]);
   // String title = message["data"];
   // String body;
    await HazizzNotification.showNotif("TEST message", message.toString());
  }

  Future<void> configure() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        await processMessage(message);
      },
      onBackgroundMessage: _backgroundMessageHandler,//myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        await processMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        await processMessage(message);
      },
    );
    print("instance id: ${await _firebaseMessaging.getToken()}");
    _firebaseMessaging.requestNotificationPermissions();
  }

  static Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
    }
    print("onBackgroundMessage: $message");
    // web config
    // await HazizzMessageHandler().processMessage(message);
  }

}