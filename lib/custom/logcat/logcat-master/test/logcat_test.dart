import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/custom/logcat/logcat-master/lib/logcat.dart';

void main() {
  const MethodChannel channel = MethodChannel('logcat');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  /*
  test('getPlatformVersion', () async {
    expect(await Logcat.platformVersion, '42');
  });
  */
}
