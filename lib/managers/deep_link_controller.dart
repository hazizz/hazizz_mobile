import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkController{

  static String createLinkToTask(int taskId){
    return "https://hazizz.page.link/?link=https://hazizz.github.io/hazizz-webclient/index.html?task=$taskId";
  }

  static void onLinkReceived(BuildContext context, Uri deepLink) async{
    HazizzLogger.printLog("DEEP LINK RECEIVED: ${deepLink.toString()}");
    if (deepLink != null) {

      HazizzLogger.printLog("sadsadasd " + deepLink.pathSegments[1]);
      if(deepLink.pathSegments[0] == "groups" /*||  deepLink.queryParameters.containsKey("group") || deepLink.queryParameters.containsKey("groups")*/){
        String strGroupId = deepLink.pathSegments[1];

        if(strGroupId == null || strGroupId == ""){
          strGroupId = deepLink.pathSegments[deepLink.pathSegments.length-1];
        }
        int groupId = int.parse(strGroupId);
        if(groupId != null){
          await showSureToJoinGroupDialog(context, groupId: groupId);
          HazizzLogger.printLog("showed showSureToJoinGroupDialog");
        }
      }else if(deepLink.queryParameters.containsKey("task")) {
        String strTaskId = deepLink.queryParameters["task"];

        if(strTaskId == null || strTaskId == "") {
          strTaskId = deepLink.pathSegments[deepLink.pathSegments.length - 1];
        }
        int taskId = int.parse(strTaskId);
        if(taskId != null) {
          Navigator.pushNamed(context, "/viewTask", arguments: taskId);
        }
      }
    }
  }

  static StreamSubscription _sub;

  static Future<Null> initUniLinks(BuildContext context) async {
    Uri initialUri = await getInitialUri();

    onLinkReceived(context, initialUri);
    _sub = getUriLinksStream().listen((Uri uri) {
      onLinkReceived(context, uri);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  static dispose(){
    _sub.cancel();
  }

}