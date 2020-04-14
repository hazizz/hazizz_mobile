


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:mobile/communication/pojos/PojoTag.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/storage/cache_manager.dart';

class FirebaseAnalyticsManager{
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  
  static Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    HazizzLogger.printLog("log event to analytics: " + name + ": " + parameters.toString());
    await analytics.logEvent(name: name, parameters: parameters);
  }

  static Future<void> logLogin(String method) async {
    HazizzLogger.printLog("log event to analytics: " + "login" + ": method: " + method);
    await analytics.logLogin(loginMethod: method);
  }

  static Future<void> logJoinGroup(int groupId) async {
    HazizzLogger.printLog("log event to analytics: " + "join_group" + ": groupId: " + groupId.toString());
    await analytics.logJoinGroup(groupId: groupId.toString());
  }

  static Future<void> logOpenedViewTaskPage(PojoTask task) async {
    HazizzLogger.printLog("log event to analytics: " + "opened_view_task_page: " + task.id.toString());
    bool isThera = false;
    for(PojoTag tag in task.tags){
      if(tag.name == "Thera"){
        isThera = true;
        break;
      }
    }
    Map<String, dynamic> parameters = {
      "task_id": task.id,
      "is_thera": isThera,
      "is_completed": task.completed == null ? "Thera" : task.completed.toString(),
      "has_subject": task.subject != null,
      "contains_image": task.description.contains("![img"),
      "has_link": task.description.contains("(http"),
    };

    await analytics.logEvent(name: "opened_view_task_page", parameters: parameters);
  }

  static Future<void> logCreatedTask(int taskId, int subjectId, List<String> tags, bool contains_image) async {
    HazizzLogger.printLog("log event to analytics: " + "created_task_page: " + taskId.toString());
    String tags_string = "";
    for(String tag in tags){
        tags_string += tag;
    }
    Map<String, dynamic> parameters = {
      "task_id": taskId,
      "has_subject": subjectId != null,
      "tags": tags_string,
      "contains_image": contains_image
    };
    await analytics.logEvent(name: "opened_view_task_page", parameters: parameters);
  }

  static Future<void> logTheme(bool isDark) async {
    String theme = isDark ? "dark" : "light";
    HazizzLogger.printLog("log event to analytics: " + "theme" + ": " + theme);

    Map<String, dynamic> parameters = {
      "theme": theme,
    };
    await analytics.logEvent(name: "theme", parameters: parameters);
  }

  static Future<void> logOpenedGroupsPage() async {
    HazizzLogger.printLog("log event to analytics: " + "opened_groups_page");

    Map<String, dynamic> parameters = {};
    await analytics.logEvent(name: "opened_groups_page", parameters: parameters);
  }

  static Future<void> logOpenedTaskCalendarPage() async {
    HazizzLogger.printLog("log event to analytics: " + "opened_task_calendar_page");

    Map<String, dynamic> parameters = {};
    await analytics.logEvent(name: "opened_task_calendar_page", parameters: parameters);
  }

  static Future<void> logOpenedGradeStatisticsPage() async {
    HazizzLogger.printLog("log event to analytics: " + "opened_grade_statistics_page");

    Map<String, dynamic> parameters = {};
    await analytics.logEvent(name: "opened_grade_statistics_page", parameters: parameters);
  }

  static Future<void> logOpenedKretaNotesPage() async {
    HazizzLogger.printLog("log event to analytics: " + "opened_kreta_notes_page");

    Map<String, dynamic> parameters = {};
    await analytics.logEvent(name: "opened_kreta_notes_page", parameters: parameters);
  }

  static Future<void> logOpenedGradeStatistics() async {
    HazizzLogger.printLog("log event to analytics: " + "opened_grade_statistics");

    Map<String, dynamic> parameters = {};
    await analytics.logEvent(name: "opened_grade_statistics", parameters: parameters);
  }

  static Future<void> logUsedLanguage(String language_code) async {
    HazizzLogger.printLog("log event to analytics: " + "used_language: " + language_code);

    Map<String, dynamic> parameters = {
      "language_code": language_code
    };
    await analytics.logEvent(name: "used_language", parameters: parameters);
  }

  static Future<void> logNumberOfKretaSessionsAdded(int count) async {
    HazizzLogger.printLog("log event to analytics: " + "number_of_kreta_sessions_added: " + count.toString());

    Map<String, dynamic> parameters = {
      "kreta_session_count": count
    };
    await analytics.logEvent(name: "number_of_kreta_sessions_added", parameters: parameters);
  }

  static Future<void> logGroupInviteLinkShare(int groupId) async {
    HazizzLogger.printLog("log event to analytics: " + "group_invite_link_share: " + groupId.toString());

    Map<String, dynamic> parameters = {
      "groupId": groupId
    };
    await analytics.logEvent(name: "group_invite_link_share", parameters: parameters);
  }

  static Future<void> logMainTabSelected(int pageIndex) async {
    Map<String, dynamic> parameters = {};
    switch(pageIndex){
      case 0:
        parameters["tab_name"] = "tasks";
        parameters["tab_index"] = 0;
        break;
      case 1:
        parameters["tab_name"] = "schedule";
        parameters["tab_index"] = 1;
        break;
      case 2:
        parameters["tab_name"] = "grades";
        parameters["tab_index"] = 2;
        break;
    }
    await logEvent("main_tab_selected", parameters);
  }

  static Future<void> logRateLimitReached() async {
    HazizzLogger.printLog("log event to analytics: " + "rate_limit_reached");

    Map<String, dynamic> parameters = {
      "user_id": CacheManager.getMyIdSafely()
    };
    await analytics.logEvent(name: "rate_limit_reached", parameters: parameters);
  }

  static Future<void> logUnknownErrorResponse() async {
    HazizzLogger.printLog("log event to analytics: " + "unknown_error_response");

    Map<String, dynamic> parameters = {
      "user_id": CacheManager.getMyIdSafely()
    };
    await analytics.logEvent(name: "unknown_error_response", parameters: parameters);
  }



}