import 'TokenManager.dart';
import 'cache_manager.dart';

class AppState{


  static Future<bool> isLoggedIn() async {
    bool refreshToken = await TokenManager.hasRefreshToken();
    String username = await InfoCache.getMyUsername();

    bool hasUsername = username != null && username != "";
    print("log: is logged in: ${refreshToken && hasUsername}");
    return refreshToken && hasUsername;
  }


}