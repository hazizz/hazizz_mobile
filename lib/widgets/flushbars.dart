import 'dart:math' as math;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/extension_methods/duration_extension.dart';
import 'package:mobile/extension_methods/string_length_limiter_extension.dart';
dynamic showHaventSavedFlushBar(BuildContext context){
  return Flushbar(
    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.slidersH),
         /* Padding(
            padding: const EdgeInsets.only(left: 3.0, top: 2),
            child: Transform.rotate(
                angle: -math.pi/2,
                child:  Icon(FontAwesomeIcons.slash, color: Colors.red,)
            ),
          ),*/
        ],
      ),
    ),
    message:  localize(context, key: "havent_saved_changes"),
    duration:  3.seconds,
  )..show(context);
}

dynamic showFlutterErrorFlushBar(BuildContext context, {@required FlutterErrorDetails flutterErrorDetails}){
  HazizzLogger.printLog("loggieg: " + flutterErrorDetails.exceptionAsString());
  Flushbar flush;
  flush =  Flushbar(
    titleText: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 3, top: 4),
          child: Icon(FontAwesomeIcons.bug, color: Colors.white,),
        ),
        Text("Exception caught!", style: TextStyle(fontSize: 18, color: Colors.white),),
      ],
    ),
    duration:  8.seconds,
    mainButton: FlatButton(
      child: Text("dismiss".localize(context).toUpperCase(), style: TextStyle(color: Colors.redAccent, fontSize: 14),),
      onPressed: (){
        flush.dismiss(true);
      },
    ),
   messageText: ConstrainedBox(
     constraints: BoxConstraints(maxHeight: 200),
     child: Container(
       child: Padding(
         padding: const EdgeInsets.all(2),
         child: Text(flutterErrorDetails.exceptionAsString(), overflow: TextOverflow.ellipsis,),
       ),
       decoration: new BoxDecoration(
         borderRadius: BorderRadius.all(Radius.circular(6)),
         color: Colors.grey
        // color: Theme.of(context).dialogBackgroundColor,
       ),
     ),
   ),
    onTap: (a) {
      Navigator.pushNamed(context, "/caught_exception_page", arguments: flutterErrorDetails);
    },
    flushbarStyle: FlushbarStyle.FLOATING,
    padding: EdgeInsets.only(left: 8, bottom: 10),
  )..show(context);
  return flush;
}

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
    message:  localize(context, key: "info_noInternetAccess"),
    duration:  3.seconds,
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
    message:  localize(context, key: "kreta_server_unavailable"),
    duration:  3.seconds,
  )..show(context);
}

dynamic showServerUnavailableFlushBar(BuildContext context){
  return Flushbar(
    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.plug, color: Colors.white,),
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
    message:  localize(context, key: "server_unavailable"),
    duration:  3.seconds,
  )..show(context);
}


dynamic showGatewayServerUnavailableFlushBar(BuildContext context){
  return Flushbar(
    onTap: (Flushbar f){
      Navigator.pushNamed(context, "/about");
    },
    flushbarStyle: FlushbarStyle.FLOATING,
    shouldIconPulse: true,

    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.plug, color: Colors.white,),
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
    message:  localize(context, key: "gateway_server_unavailable"),
    duration:  4.seconds,
  )..show(context);
}
dynamic showAuthServerUnavailableFlushBar(BuildContext context){
  return Flushbar(
    onTap: (Flushbar f){
      Navigator.pushNamed(context, "/about");
    },
    flushbarStyle: FlushbarStyle.FLOATING,
    shouldIconPulse: true,

    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.plug, color: Colors.white,),
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
    message:  localize(context, key: "auth_server_unavailable"),
    duration:  4.seconds,
  )..show(context);
}
dynamic showHazizzServerUnavailableFlushBar(BuildContext context){
  return Flushbar(
    onTap: (Flushbar f){
      Navigator.pushNamed(context, "/about");
    },
    flushbarStyle: FlushbarStyle.FLOATING,
    shouldIconPulse: true,

    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.plug, color: Colors.white,),
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
    message:  localize(context, key: "hazizz_server_unavailable"),
    duration:  4.seconds,
  )..show(context);
}
dynamic showTheraServerUnavailableFlushBar(BuildContext context){
  return Flushbar(
    onTap: (Flushbar f){
      Navigator.pushNamed(context, "/about");
    },
    flushbarStyle: FlushbarStyle.FLOATING,
    shouldIconPulse: true,

    icon: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Stack(
        children: <Widget>[
          Icon(FontAwesomeIcons.plug, color: Colors.white,),
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
    message:  localize(context, key: "thera_server_unavailable"),
    duration:  4.seconds,
  )..show(context);
}

dynamic showSessionFailFlushBar(BuildContext context){
  return Flushbar(
    flushbarStyle: FlushbarStyle.FLOATING,
    shouldIconPulse: true,

    icon: Icon(FontAwesomeIcons.userTimes, color: Colors.red,),
    message:  localize(context, key: "failed_session"),
    duration:  4.seconds,
  )..show(context);
}


void showReportSuccessFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.solidFlag, color: Colors.green,),
    message:  localize(context, key: "report_successful", args: [what]),
    duration:  4.seconds,
  )..show(context);
}

void showDeleteWasSuccessfulFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.times, color: Colors.green,),
    message:  localize(context, key: "subscribed_to_subject", args: [what]),
    duration:  4.seconds,
  )..show(context);
}

void showSubscribedToSubjectFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.check, color: Colors.green,),
    message:  localize(context, key: "subscribed_to_subject", args: [what]),
    duration: 3.seconds,
  )..show(context);
}

void showUnsubscribedFromSubjectFlushBar(BuildContext context, {@required String what}){
  Flushbar(
    icon: Icon(FontAwesomeIcons.times, color: Colors.red,),
    message:  localize(context, key: "unsubscribed_from_subject", args: [what]),
    duration:  3.seconds,
  )..show(context);
}

