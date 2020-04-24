import 'package:flutter/widgets.dart';

class BusinessNavigator{
  static final BusinessNavigator _singleton = new BusinessNavigator._internal();
  factory BusinessNavigator() {
    return _singleton;
  }
  BusinessNavigator._internal();


   final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

   NavigatorState currentState() {
    return navigatorKey.currentState;
  }


}