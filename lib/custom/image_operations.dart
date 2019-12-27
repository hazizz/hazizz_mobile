

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as package;

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/services/hazizz_crypt.dart';


class EncryptedImageData{
  File originalImage;
  String encryptedData;
  String iv;
  String key;
  EncryptedImageData(this.originalImage, this.encryptedData, this.iv, this.key){

  }
}

Uint8List fromBase64ToBytesImage(String base64) {
    return ImageOpeations.fromBase64ToBytesImage(base64);
}

String fromBytesImageToBase64 (Uint8List bytes) {
  return ImageOpeations.fromBytesImageToBase64(bytes);
}

class ImageOpeations{


  static Uint8List fromBase64ToBytesImage(String base64) {
    return base64Decode(base64);
  //  return Image.memory(a);
  }

  static String fromBytesImageToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  static Future<File> pick() async {
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

      // profileEditorBlocs.pictureEditorBloc.dispatch(ProfilePictureEditorChangedEvent(imageBytes: image.readAsBytesSync()));

      //  Clipboard.setData(new ClipboardData(text: image.readAsBytesSync().toString()));
      return image;
    }catch(e){
      return null;
    }
  }

  static Future<EncryptedImageData> pickAndEncrypt() async {
    File f = await pick();
    if(f == null){
      return null;
    }

    String key = HazizzCrypt.generateKey();
    String iv = HazizzCrypt.generateIv();
    String encryptedData = HazizzCrypt.encrypt(base64.encode(f.readAsBytesSync()), key, iv); //encrypt

    return EncryptedImageData(f, encryptedData, iv, key);
  }

}