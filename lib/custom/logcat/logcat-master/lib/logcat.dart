// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// Plugin for fetching the app logs
class Logcat {
  /// [MethodChannel] used to communicate with the platform side.
  static const platform = const MethodChannel('app.channel.logcat');

  /// Fetches the app logs by executing the logcat command-line tool.
  /// May throw [PlatformException] from [MethodChannel].
  static Future<String> execute() async {
    if (Platform.isIOS) {
      return 'Logs can only be fetched from Android Devices presently.';
    }
    String logs;
    try {
      logs = await platform.invokeMethod('execLogcat');
    } on PlatformException catch (e) {
      logs = "Failed to get logs: '${e.message}'.";
    }

    return logs;
  }
}
