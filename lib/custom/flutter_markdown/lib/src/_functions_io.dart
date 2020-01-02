// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mobile/communication/request_sender.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/services/hazizz_crypt.dart';

import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart' show CircularProgressIndicator, Colors, Theme;
import 'package:flutter/widgets.dart';

import 'style_sheet.dart';
import 'widget.dart';

typedef Widget ImageBuilder(Uri uri, String imageDirectory, double width, double height);

final ImageBuilder kDefaultImageBuilder = (
  Uri uri,
  String imageDirectory,
  double width,
  double height,
  {String key}
) {
  print("mivan?00");
  if (uri.scheme == 'http' || uri.scheme == 'https') {
    print("mivan?0");
    if(uri.host == "transfer.sh"){

      print("mivan?1");
      String url = uri.toString();
      int i = url.indexOf("~~");
      print("mivan?2");
      url = url.substring(0, i);
      print("mivan?3");

      return FutureBuilder(
        future: RequestSender().getResponse(new GetUploadedImage(
          url: url
        )),
        builder: (context, responseState){
          if(responseState.connectionState == ConnectionState.done){
            String cryptedBase64Img = responseState.data.convertedData;
            String base64Img = HazizzCrypt.decrypt(cryptedBase64Img, key);
            Uint8List byteImg = Base64Decoder().convert(base64Img);
            Image img = Image.memory(byteImg);
            return Container(child: img,);
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      );
    }
    return Container(color: Colors.red, width:  20, height: 20,);
   // return Image.network(uri.toString(), width: width, height: height);
  } else if (uri.scheme == 'data') {
    return _handleDataSchemeUri(uri, width, height);
  } else if (uri.scheme == "resource") {
    return Image.asset(uri.path, width: width, height: height);
  } else {
    Uri fileUri = imageDirectory != null ? Uri.parse(imageDirectory + uri.toString()) : uri;
    if (fileUri.scheme == 'http' || fileUri.scheme == 'https') {
      return Image.network(fileUri.toString(), width: width, height: height);
    } else {
      return Image.file(File.fromUri(fileUri), width: width, height: height);
    }
  }
};

final MarkdownStyleSheet Function(BuildContext, MarkdownStyleSheetBaseTheme) kFallbackStyle = (
  BuildContext context,
  MarkdownStyleSheetBaseTheme baseTheme,
) {
  switch (baseTheme) {
    case MarkdownStyleSheetBaseTheme.platform:
      return (Platform.isIOS || Platform.isMacOS)
          ? MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context))
          : MarkdownStyleSheet.fromTheme(Theme.of(context));
    case MarkdownStyleSheetBaseTheme.cupertino:
      return MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context));
    case MarkdownStyleSheetBaseTheme.material:
    default:
      return MarkdownStyleSheet.fromTheme(Theme.of(context));
  }
};

Widget _handleDataSchemeUri(Uri uri, final double width, final double height) {
  final String mimeType = uri.data.mimeType;
  if (mimeType.startsWith('image/')) {
    return Image.memory(
      uri.data.contentAsBytes(),
      width: width,
      height: height,
    );
  } else if (mimeType.startsWith('text/')) {
    return Text(uri.data.contentAsString());
  }
  return const SizedBox();
}
