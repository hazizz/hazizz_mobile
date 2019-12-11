import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';
import 'package:mobile/blocs/auth/google_login_bloc.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'google_http_client.dart';

class Database {
  static final Database _singleton = Database._internal();

  factory Database() {
    return _singleton;
  }

  Database._internal();

  DriveApi drive;

  static const String hazizzFolderName = "Házizz Mobile titkisitott képek";

  Future<void> initialize() async {
    final _googleSignIn = new GoogleSignIn(
      scopes: [
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/userinfo.profile",
        "openid",
        "https://www.googleapis.com/auth/drive.appdata",
        "https://www.googleapis.com/auth/drive.file",
        'https://www.googleapis.com/auth/drive.readonly',
        'https://www.googleapis.com/auth/drive'

      ],
    );
    await _googleSignIn.signIn();
    final authHeaders = await _googleSignIn.currentUser.authHeaders;
    final httpClient = GoogleHttpClient(authHeaders);
    drive = DriveApi(httpClient);
  }

  /*
  Future<String> getImageFromDrive(
      String accessToken, String fileId) async {
    DriveApi drive = DriveApi(Client());
    File driveFile = await drive.files.get(file, );



    /* final headers = {'Authorization': 'Bearer $accessToken'};
    final url = 'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';
    final response = await get(url, headers: headers);
    return _jsonToGroups(utf8.decode(response.bodyBytes));
    */
  }
  */

  Future<File> getHazizzFolder() async {
    File hazizzFolder;
    print("pesti pip <3: 1");

    FileList hazizzFolderList = await drive.files.list(
    // q: "mimeType='application/vnd.google-apps.folder' and name = '$hazizzFolderName'"
       q: "name='$hazizzFolderName'"
    );
    print("pesti pip <3: 2");

    if(hazizzFolderList.files == null || hazizzFolderList.files.isEmpty){
      print("pesti pip <3: 2.1");

      hazizzFolder = await createFolder();
      print("pesti pip <3: 2.2");

    }else{
      hazizzFolder = hazizzFolderList.files[0];
    }
    print("pesti pip <3: 3");

    return hazizzFolder;
  }

  Future<File> createFolder() async {
    print("pesti pip <3: 4");

    File folder =  File()
      ..name = hazizzFolderName
      ..mimeType = "application/vnd.google-apps.folder"
    ;
    print("pesti pip <3: 5");

    folder = await drive.files.create(folder, $fields: "id");
    print("pesti pip <3: 6");

    return folder;
  }

  Future<Uri> uploadImageToDrive(EncryptedImageData d) async {

    print("pesti pip <3: 0");
    String folderId = (await getHazizzFolder()).id;
    print("pesti pip <3: 30");

    Permission permission = Permission()
      ..type = "anyone"
      ..role = "reader"
    ;

    File drivef =  File()
      ..name = "${DateTime.now()}.jpg"
      ..parents = [folderId]
    ;


    File driveFile = await drive.files.create(drivef, uploadMedia: Media(d.originalImage.openRead(), d.originalImage.lengthSync()));

    permission.allowFileDiscovery = true;

    Permission a = await drive.permissions.create(permission, driveFile.id, supportsAllDrives: true, supportsTeamDrives: true, );

    print("brughh001: ${a}, ${a.type}, ${a.role}");

    driveFile = await drive.files.get(driveFile.id, $fields: "webContentLink");//"files/webViewLink");


    print("brughh000: ${driveFile.permissions.toString()}");

    print("brughh0: ${driveFile.driveId}");

    print("brughh1: ${driveFile.name}");
    print("brughh2: ${driveFile.webViewLink}");
    print("brughh3: ${driveFile.thumbnailLink}");
    print("brughh4: ${driveFile.webContentLink}");

    return Uri.parse(driveFile.webContentLink);
  }
}
