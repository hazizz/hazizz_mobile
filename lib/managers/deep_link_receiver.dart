import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:uni_links/uni_links.dart';

class DeepLink{

  static String createLinkToTask(int taskId){
    return "https://hazizz.page.link/?link=https://hazizz.github.io/hazizz-webclient/index.html?task=$taskId";
  }

  static void onLinkReceived(BuildContext context, Uri deepLink) async{
    HazizzLogger.printLog("DEEP LINK RECEIVED: ${deepLink.toString()}");
    if (deepLink != null) {

      HazizzLogger.printLog("sadsadasd " + deepLink.pathSegments[1]);
      if(deepLink.pathSegments[0] == "groups" /*||  deepLink.queryParameters.containsKey("group") || deepLink.queryParameters.containsKey("groups")*/){
       // String str_groupId = deepLink.queryParameters["groups"];
        String str_groupId = deepLink.pathSegments[1];

        if(str_groupId == null || str_groupId == ""){
          str_groupId = deepLink.pathSegments[deepLink.pathSegments.length-1];
        }
        int groupId = int.parse(str_groupId);
        if(groupId != null){
          await showSureToJoinGroupDialog(context, groupId: groupId);
          HazizzLogger.printLog("showed showSureToJoinGroupDialog");
        }
      }else if(deepLink.queryParameters.containsKey("task")) {
        String str_taskId = deepLink.queryParameters["task"];

        if(str_taskId == null || str_taskId == "") {
          str_taskId = deepLink.pathSegments[deepLink.pathSegments.length - 1];
        }
        int taskId = int.parse(str_taskId);
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