


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class FirebaseAnalyticsManager{
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  
  static void logEvent(String name, Map<String, dynamic> parametars){
    analytics.logEvent(name: name, parameters: parametars);
  }
}