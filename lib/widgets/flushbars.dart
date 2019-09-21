
import 'dart:math' as math;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../hazizz_localizations.dart';


dynamic showNoConnectionFlushBar(BuildContext context, {@required GlobalKey<ScaffoldState> scaffoldState}){

  return Flushbar(
    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.wifi, color: Colors.white,),
          Padding(
            padding: const EdgeInsets.only(left: 3.0, top: 2),
            child: Transform.rotate(
                angle: -math.pi/2,
                child:  Icon(FontAwesomeIcons.slash, color: Colors.red,)
            ),
          ),
        ],
      ),
    ),
    message:  locText(context, key: "info_noInternetAccess"),
    duration:  Duration(seconds: 3),
  )..show(context);

  return scaffoldState.currentState.showSnackBar(SnackBar(
    content: Text(locText(context, key: "info_noInternetAccess")),
    duration: Duration(seconds: 3),
  ));
}

dynamic showKretaUnavailableFlushBar(BuildContext context, {@required GlobalKey<ScaffoldState> scaffoldState}){
 /* return scaffoldState.currentState.showSnackBar(SnackBar(
    content: Text(locText(context, key: "kreta_server_unavailable")),
    duration: Duration(seconds: 3),
  ));
  */

  return Flushbar(
    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.landmark, color: Colors.white,),
          Padding(
            padding: const EdgeInsets.only(left: 3.0, top: 2),
            child: Transform.rotate(
                angle: -math.pi/2,
                child:  Icon(FontAwesomeIcons.slash, color: Colors.red,)
            ),
          ),
        ],
      ),
    ),
    message:  locText(context, key: "kreta_server_unavailable"),
    //  message:  "Lorem Ipsum is simply dummy text of the HazizzLogger.printLoging and typesetting industry",
    duration:  Duration(seconds: 3),
  )..show(context);
}


void showReportSuccessFlushBar(BuildContext context, {String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.solidFlag, color: Colors.green,),
    message:  locText(context, key: "report_successful", args: [what]),
  //  message:  "Lorem Ipsum is simply dummy text of the HazizzLogger.printLoging and typesetting industry",
    duration:  Duration(seconds: 4),
  )..show(context);
}

void showDeleteWasSuccessfulFlushBar(BuildContext context, {String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.times, color: Colors.green,),
    message:  locText(context, key: "delete_successful", args: [what]),
    //  message:  "Lorem Ipsum is simply dummy text of the HazizzLogger.printLoging and typesetting industry",
    duration:  Duration(seconds: 4),
  )..show(context);
}
