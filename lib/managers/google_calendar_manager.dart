import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:mobile/communication/pojos/task/PojoTask.dart';
import 'package:mobile/managers/deep_link_controller.dart';

import '../services/google_http_client.dart';

class GoogleCalendarColorIds{
  static const String blue = "1",
      green = "2",
      purple = "3",
      red = "4",
      yellow = "5",
      orange = "6",
      turquoise = "7",
      gray = "8",
      bold_blue = "9",
      bold_green = "10",
      bold_red = "11"
  ;
}

class GoogleCalendarManager {
  static final GoogleCalendarManager _singleton = GoogleCalendarManager._internal();
  factory GoogleCalendarManager() {
    return _singleton;
  }
  GoogleCalendarManager._internal();

  CalendarApi calendarApi;

  DateTime lastTokenTime;

  GoogleSignIn _googleSignIn;

  static const String hazizzFolderName = "hazizz_mobile_images";

  static const String gDriveAccessScope = "https://www.googleapis.com/auth/drive.file";

  Future<bool> initialize() async {
    if(calendarApi == null || lastTokenTime == null ||
        DateTime.now().difference(lastTokenTime).inMinutes > 50){
      _googleSignIn = new GoogleSignIn(
        scopes: [
          "https://www.googleapis.com/auth/calendar.events"
        ],
      );
    //  GoogleSignInAccount account = await _googleSignIn.signInSilently(suppressErrors: false);
      GoogleSignInAccount account = await _googleSignIn.signIn();

      debugPrint("access Token 2: ${(await account.authentication).accessToken}");

      final authHeaders = await _googleSignIn.currentUser.authHeaders;

      final httpClient = GoogleHttpClient(authHeaders);

      calendarApi = CalendarApi(httpClient);

      lastTokenTime = DateTime.now();
    }
    print("Google Drive initialized!");
    return true;
  }

  Future<void> addTaskEvent({@required PojoTask task}) async {
    String tag = "";
    if(task.tags != null && task.tags.isNotEmpty){
      tag = await task.tags.firstWhere((t){
        return t.isDefault;
      })?.getDisplayNameAsync();
      tag ??= (await task.tags[0]?.getDisplayNameAsync()) ?? "";
    }
    Event hazizzTaskEvent =
    Event()
      ..htmlLink = "https://www.facebook.com"
      ..start = (EventDateTime()..date = task.dueDate)
      ..colorId = GoogleCalendarColorIds.bold_red
      ..end = (EventDateTime()..date = task.dueDate)
      ..description = "${task.description}\n\nView this task in Hazizz Mobile:\n${DeepLinkController.createLinkToTask(task.id)}"
      ..creator = (EventCreator()..displayName = task.creator.displayName)
      ..summary = "Házizz - ${task.tags[0].getDisplayNameAsync()} - ${task.subject.name}"
      ..attachments = [EventAttachment()
                        ..fileUrl = "https://drive.google.com/open?id=1XyEugm8YWGYPWQA8zXzXi1rseiaIROoC"
                        ..title = "Hazizz image"
                        ..mimeType = "image/jpg"
                        ,
                      ]
      ..iCalUID = "hazizz_task3"
    ;
    await calendarApi.events.insert(hazizzTaskEvent, "primary", sendNotifications: true, );
  }
}
