import 'dart:ui' as ui;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:googleapis/drive/v3.dart' as driveapi;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/managers/google_drive_manager.dart';
import 'package:mobile/services/hazizz_crypt.dart';
import 'package:mobile/widgets/image_viewer_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imagePackage;
import 'package:mobile/extension_methods/duration_extension.dart';

class HazizzImageData{
  final ImageType imageType;

  File imageFile;

  String thumbnailUrl;

  String encryptedData;
  String key;

  String url;
  String driveFileId;
  String driveName;

 // HazizzImageData(this.imageFile, this.encryptedData, this.key);

  HazizzImageData.fromFile(this.imageFile) :  imageType = ImageType.FILE;
  HazizzImageData.fromNetwork(this.url) : imageType = ImageType.NETWORK;

  HazizzImageData.fromGoogleDrive(this.url, this.key) : imageType = ImageType.GOOGLE_DRIVE;

  Function currentAsyncTask;


  Future futureUploadedToDrive = Future.delayed(60.seconds);

  Future<void> _uploadToGDrive() async {
    driveapi.File f = await GoogleDriveManager().uploadImageToDrive(this);
    url = f.webContentLink;
    driveFileId = f.id;
    driveName = f.name;
  }

  Future<void> renameFile(int taskId) async {
    GoogleDriveManager().renameHazizzImage(fileId: driveFileId, oldName: driveName, taskId: taskId);
  }

  Future<void> uploadToGDrive() async {
    futureUploadedToDrive = _uploadToGDrive();
  }

  Future<void> removeFromGDrive() async {

  }

  void compressEncryptAndUpload(String key){
    compress().then((val){
      encrypt(key);
      uploadToGDrive();
    });
  }


  void encrypt(String key) async {
    assert (imageFile != null);
    print("encrypt: ${imageFile?.path} ${key}");
    if(imageFile != null){


      print("melody oof: ${key}");

      print("hason0: ${imageFile.readAsBytesSync()}");

      String encryptedData2 = HazizzCrypt.encrypt(base64.encode(imageFile.readAsBytesSync()), key); //encrypt

      this.encryptedData = encryptedData2;
      this.key = key;
    }
  }

  Future<void> compress() async {
    currentAsyncTask = _compress;
    await currentAsyncTask();
  }

  Future<void> _compress() async {
    assert(imageFile != null);
    if(imageFile != null){
      double q = 100;
      print("asdasda: 1: ${imageFile.absolute.path}");
      final int imageSizeInBytes = imageFile.lengthSync();
      print("asdasda: 2: $imageFile");
      if(imageSizeInBytes > 1000000){
        q = 1000000 / imageSizeInBytes * 100;
      }


      final directory = await getTemporaryDirectory();
      print("asdasda: 3: $q, ${directory.path}");
      File compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        directory.path + "/ize.jpg",
        quality: q.floor(),
      );
      print("asdasda: 4");
      imageFile = compressedImage;
      print("asdasda: 5: ${imageFile}");
    }
  }

  Future<String> getBase64ThumbnailImage() async {

    if(imageType != ImageType.GOOGLE_DRIVE){

      imagePackage.Image img = decodeImage(imageFile.readAsBytesSync());

      imagePackage.Image thumbnail;

      if(img.width >= img.height){
        thumbnail = copyResize(img, width: 120);
      }else{
        thumbnail = copyResize(img, height: 120);
      }

      return base64UrlEncode(encodeJpg(thumbnail));
    }
    return null;


    if(imageType != ImageType.GOOGLE_DRIVE){
      return base64UrlEncode(imageFile.readAsBytesSync());
      Uint8List m = imageFile.readAsBytesSync();
      ui.Image x = await decodeImageFromList(m);
      ByteData bytes = await x.toByteData();
      print('height is ${x.height}'); //height of original image
      print('width is ${x.width}'); //width of oroginal image

      print('array is $m');
      print('original image size is ${bytes.lengthInBytes}');

      final directory = await getTemporaryDirectory();
      File thumbnailImage = File("${directory.path}/thumbnail.jpg");
      thumbnailImage.createSync();
      ui.Codec codec = await ui.instantiateImageCodec(m, targetHeight: 256, targetWidth: 256);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      ui.Image i = frameInfo.image;
      print('image width is ${i.width}');//height of resized image
      print('image height is ${i.height}');//width of resized image
      bytes = await i.toByteData();
      thumbnailImage.writeAsBytes(bytes.buffer.asUint32List());
      print('resized image size is ${bytes.lengthInBytes}');
      String base64Thumbnail = base64UrlEncode(thumbnailImage.readAsBytesSync());
      thumbnailImage.delete();
      return base64Thumbnail;
    }
  }

}

Uint8List fromBase64ToBytesImage(String base64) {
    return ImageOperations.fromBase64ToBytesImage(base64);
}

String fromBytesImageToBase64 (Uint8List bytes) {
  return ImageOperations.fromBytesImageToBase64(bytes);
}

class ImageOperations{

  static Uint8List fromBase64ToBytesImage(String base64) {
    return base64Decode(base64);
  //  return Image.memory(a);
  }

  static String fromBytesImageToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  static Future<HazizzImageData> pick() async {
    try{
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      /*  image = await ImageCropper.cropImage(
      controlWidgetColor: Theme.of(context).primaryColor,
      controlWidgetVisibility: false,
      circleShape: true,
      toolbarColor: Theme.of(context).primaryColor,
      toolbarWidgetColor: Theme.of(context).iconTheme.color,
      toolbarTitle: locText(context, key: "edit_profile_picture"),
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );*/
      if(image == null){
        return null;
      }
      /*
    package.Image im = package.decodeImage(image.readAsBytesSync());

    List<String> a = image.path.split("/");

    print(package.encodeNamedImage(im, a[a.length-1]));
    */

      // profileEditorBlocs.pictureEditorBloc.add(ProfilePictureEditorChangedEvent(imageBytes: image.readAsBytesSync()));

      //  Clipboard.setData(new ClipboardData(text: image.readAsBytesSync().toString()));
      return HazizzImageData.fromFile(image);
    }catch(e){
      return null;
    }
  }

  /*
  static Future<HazizzImageData> pickAndEncrypt() async {
    var f = await pick();
    if(f == null){
      return null;
    }
    String key = Uuid().v4().substring(0, 32);

    print("melody oof: ${key}");

    String encryptedData = HazizzCrypt.encrypt(base64.encode(f.readAsBytesSync()), key); //encrypt

    return HazizzImageData(f, encryptedData, key);
  }
  */
  
  /*
  Future<HazizzImageData> encrypt2(File file, {@required String key}) async {
    if(file == null){
      return null;                                                                                
    }                                                                                             

                                                                                                  
    print("melody oof: ${key}");                                                                  
                                                                                                  
    String encryptedData = HazizzCrypt.encrypt(base64.encode(file.readAsBytesSync()), key); //encrypt
                                                                                                  
    return HazizzImageData(file, encryptedData, key);                                             
  }
  */
}                                                                                               