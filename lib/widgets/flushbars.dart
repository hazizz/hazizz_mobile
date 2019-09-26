
import 'dart:math' as math;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../hazizz_localizations.dart';


dynamic showNoConnectionFlushBar(BuildContext context){

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
}

dynamic showKretaUnavailableFlushBar(BuildContext context){

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
    duration:  Duration(seconds: 3),
  )..show(context);
}


void showReportSuccessFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.solidFlag, color: Colors.green,),
    message:  locText(context, key: "report_successful", args: [what]),
    duration:  Duration(seconds: 4),
  )..show(context);
}

void showDeleteWasSuccessfulFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.times, color: Colors.green,),
    message:  locText(context, key: "subscribed_to_subject", args: [what]),
    duration:  Duration(seconds: 4),
  )..show(context);
}

void showSubscribedToSubjectFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.check, color: Colors.green,),
    message:  locText(context, key: "subscribed_to_subject", args: [what]),
    duration:  Duration(seconds: 3),
  )..show(context);
}

void showUnsubscribedFromSubjectFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.times, color: Colors.red,),
    message:  locText(context, key: "unsubscribed_from_subject", args: [what]),
    duration:  Duration(seconds: 3),
  )..show(context);
}

