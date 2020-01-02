import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:mobile/custom/image_operations.dart';

class ImageUploaderIsolate{

  Isolate isolate;

  HazizzImageData imageData;

  void start(HazizzImageData imageData) async {
    this.imageData = imageData;
    ReceivePort receivePort= ReceivePort(); //port for this main isolate to receive messages.
    isolate = await Isolate.spawn(execute, receivePort.sendPort);
    receivePort.listen((dynamic data) {
      SendPort mainToIsolateStream = data;

      HazizzImageData returnedImageData = data;

      stdout.write('RECEIVE: ' + data + ', ');
      return returnedImageData;
    });
  }

  Future<void> execute(SendPort sendPort) async {

    await imageData.compress();
    imageData.encrypt("");
    await imageData.uploadToGDrive();

    sendPort.send(imageData);

    stop();
  }

  void stop() {
    if (isolate != null) {
      stdout.writeln('killing isolate');
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }






  Future<SendPort> initIsolate() async {
    Completer completer = new Completer<SendPort>();
    ReceivePort isolateToMainStream = ReceivePort();

    isolateToMainStream.listen((data) {
      if (data is SendPort) {
        SendPort mainToIsolateStream = data;
        completer.complete(mainToIsolateStream);
      } else {
        print('[isolateToMainStream] $data');
      }
    });

    Isolate myIsolateInstance = await Isolate.spawn(execute2, isolateToMainStream.sendPort);
    return completer.future;
  }

  void execute2(SendPort isolateToMainStream) {
    ReceivePort mainToIsolateStream = ReceivePort();
    isolateToMainStream.send(mainToIsolateStream.sendPort);

    mainToIsolateStream.listen((data) {
      print('[mainToIsolateStream] $data');
    });

    isolateToMainStream.send('This is from myIsolate()');
  }
}