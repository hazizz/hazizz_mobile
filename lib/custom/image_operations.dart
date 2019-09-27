

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';


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

}