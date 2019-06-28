import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class HashedTextEditingController extends TextEditingController{
  String get text => (sha256.convert(utf8.encode(value.text))).toString();
}