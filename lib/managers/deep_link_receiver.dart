import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:uni_links/uni_links.dart';

class DeepLink{


  static void onLinkReceived(BuildContext context, Uri deepLink) async{

    HazizzLogger.printLog("HazizzLog: DEEP LINK RECEIVED: ${deepLink.toString()}");
    if (deepLink != null) {
      String str_groupId = deepLink.queryParameters["group"];

      if(str_groupId == null && str_groupId == ""){
        str_groupId = deepLink.pathSegments[deepLink.pathSegments.length-1];
      }

      int groupId = int.parse(str_groupId);
      if(groupId != null){
        await showSureToJoinGroupDialog(context, groupId: groupId);
        HazizzLogger.printLog("HazizzLog: showed showSureToJoinGroupDialog");
      }

    }
  }

  static StreamSubscription _sub;

  static Future<Null> initUniLinks(BuildContext context) async {
    Uri initialUri = await getInitialUri();


    onLinkReceived(context, initialUri);
    // Attach a listener to the stream
    _sub = getUriLinksStream().listen((Uri uri) {
      onLinkReceived(context, uri);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  static dispose(){
    _sub.cancel();
  }

}