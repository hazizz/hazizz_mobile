import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/image_operations.dart';
import 'package:path_provider/path_provider.dart';

import '../google_http_client.dart';

class GoogleDriveManager {
  static final GoogleDriveManager _singleton = GoogleDriveManager._internal();

  factory GoogleDriveManager() {
    return _singleton;
  }

  GoogleDriveManager._internal();
  DriveApi driveApi;
  DateTime lastTokenTime;
  GoogleSignIn _googleSignIn;

  static const String hazizzFolderName = "hazizz_mobile";

  static const String gDriveAccessScope = "https://www.googleapis.com/auth/drive.file";

  Future<bool> initialize() async {
    if(driveApi == null || lastTokenTime == null ||
       DateTime.now().difference(lastTokenTime).inMinutes > 50){
      _googleSignIn = new GoogleSignIn(
        scopes: [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/userinfo.profile",
          "openid",
          gDriveAccessScope,
        ],
      );
      GoogleSignInAccount account = await _googleSignIn.signIn();

      debugPrint("access Token 2: ${(await account.authentication).accessToken}");

      final authHeaders = await _googleSignIn.currentUser.authHeaders;

      final httpClient = GoogleHttpClient(authHeaders);
      driveApi = DriveApi(httpClient);

      lastTokenTime = DateTime.now();
    }
    print("Google Drive initialized!");

    return true;
  }

  bool gDriveAccessGranted(){
    return _googleSignIn?.scopes?.contains(gDriveAccessScope) ?? false;
  }

  Future<void> renameHazizzImage({@required String fileId, @required String oldName, @required int taskId}) async {
    HazizzLogger.printLog("deleting Hazizz Image: $fileId}");

    File f = File()..name = "${taskId}_" + oldName;
    await driveApi.files.update(f, fileId);
  }
  

  Future<FileList> getAllHazizzImages() async {
    File folder = await getHazizzFolder();
    FileList list = await driveApi.files.list(q: "'${folder.id}' in parents", $fields: "files/webContentLink, files/id, files/thumbnailLink, files/name");
    return list;
  }

  Future<void> deleteAllHazizzImages() async {
    File folder = await getHazizzFolder();
    FileList list = await driveApi.files.list(
      q: "'${folder.id}' in parents",
      $fields: "files/id"
    );

    for(File f in list.files){
      await driveApi.files.delete(f.id);
    }
  }

  Future<void> deleteHazizzImage(String fileId) async {
    HazizzLogger.printLog("deleting Hazizz Image: $fileId}");
    await driveApi.files.delete(fileId);
  }


  Future<File> getHazizzFolder() async {
    File hazizzFolder;
    print("pesti pip <3: 1");

    FileList hazizzFolderList = await driveApi.files.list(
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
      ..description = "Please, do not edit this folder";
    ;
    print("pesti pip <3: 5");

    folder = await driveApi.files.create(folder, $fields: "id");
    print("pesti pip <3: 6");

    return folder;
  }

  Future<File> uploadImageToDrive(HazizzImageData d) async {

    print("pesti pip <3: 0");
    String folderId = (await getHazizzFolder()).id;
    print("pesti pip <3: 30");

    Permission permission = Permission()
      ..type = "anyone"
      ..role = "reader"
    ;


    print("hason1: ${d.encryptedData}");

    final directory = await getTemporaryDirectory();
    final tempFile = io.File('${directory.path}/img.txt');
    tempFile.writeAsStringSync(d.encryptedData);

    print("tempFile: ${tempFile.readAsStringSync()}");

    File drivef =  File()
      ..name = "${DateTime.now()}.hazizzpic"
      ..parents = [folderId]
      ..contentHints =
        (FileContentHints()..thumbnail =
          (FileContentHintsThumbnail()
            ..image = await d.getBase64ThumbnailImage()
            ..mimeType = "image/jpg"
          )
        )
    ;


    File driveFile = await driveApi.files.create(drivef, uploadMedia: Media(tempFile.openRead(), tempFile.lengthSync()), $fields: "webContentLink, id, name"); // thumbnailLink,


    tempFile.delete();

    permission.allowFileDiscovery = true;

    Permission a = await driveApi.permissions.create(permission, driveFile.id, supportsAllDrives: true, supportsTeamDrives: true, );

    print("brughh001: ${a}, ${a.type}, ${a.role}");

  //  driveFile = await driveApi.files.get(driveFile.id, $fields: "webContentLink, thumbnailLink, id");//"files/webViewLink");


    print("brughh000: ${driveFile.permissions.toString()}");

    print("brughh0: ${driveFile.id}");

    print("brughh1: ${driveFile.name}");
    print("brughh2: ${driveFile.webViewLink}");
    print("brughh3: ${driveFile.thumbnailLink}");
    print("brughh4: ${driveFile.webContentLink}");

    return driveFile;
  }
}
