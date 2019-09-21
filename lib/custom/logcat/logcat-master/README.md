# logcat

Flutter plugin to get system messages, stack traces etc and show them in app. Can also be used to get the app logs from a remote device with share plugin.

Call Logcat.exec() from anywhere to get logs as a Future String then use it in anyway within your app.

NOTE: This plugin fetches logs only on Android Devices presently.

### Installation

#### Add package to pubspec.yaml

```sh
logcat: ^1.0.2
```

#### Add Import

```sh
import 'package:logcat/logcat.dart';
```

#### Use it anywhere

```sh
Future<void> _getLogs() async {
    final String logs = await Logcat.execute();
    setState(() {
      // Update your UI
    });
  }
```
