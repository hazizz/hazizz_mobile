import 'dart:io' as io;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:mobile/custom/image_operations.dart';

import 'google_http_client.dart';

class GoogleDriveManager {
  static final GoogleDriveManager _singleton = GoogleDriveManager._internal();

  factory GoogleDriveManager() {
    return _singleton;
  }

  GoogleDriveManager._internal();

  DriveApi drive;

  DateTime lastTokenTime;

  static const String hazizzFolderName = "Házizz Mobile titkisitott képek";

  Future<void> initialize() async {
    if(drive == null || lastTokenTime == null ||
       lastTokenTime.difference(DateTime.now()).inMinutes > 50){
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

      lastTokenTime = DateTime.now();
    }
    print("Google Drive initialized!");
  }


  Future<FileList> getAllHazizzImages() async {
    File folder = await getHazizzFolder();
    FileList list = await drive.files.list(q: "'${folder.id}' in parents", $fields: "files/webContentLink, files/id");

   /* List<String> urls = [];
    for(File f in list.files){
     urls.add(f.webContentLink);
    }
    */
    return list;
  }

  Future<void> deleteAllHazizzImages() async {
    File folder = await getHazizzFolder();
    FileList list = await drive.files.list(q: "'${folder.id}' in parents", $fields: "files/id");

    for(File f in list.files){

      await drive.files.delete(f.id);
    }
  }

  Future<void> deleteHazizzImage(String fileId) async {
    await drive.files.delete(fileId);
  }


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
      ..description = "Please do not edit this folder";
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


    double q = 100;

    final int imageSizeInBytes = d.originalImage.lengthSync();

    if(imageSizeInBytes > 1000000){
      q = 1000000 / imageSizeInBytes * 100;
    }

    io.File image = await FlutterImageCompress.compressAndGetFile(
      d.originalImage.absolute.path,
      d.originalImage.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: q.floor(),

    );


    File driveFile = await drive.files.create(drivef, uploadMedia: Media(image.openRead(), image.lengthSync()));

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
