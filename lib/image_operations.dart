import 'dart:convert';

import 'package:flutter/material.dart';

Image imageFromBase64String(String base64String) {
    return ImageOpeations.fromBase64String(base64String);
}

class ImageOpeations{


  static Image fromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }


}