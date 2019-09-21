import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logcat/logcat.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _logs = 'Nothing yet';

  @override
  void initState() {
    super.initState();
    _getLogs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Logcat Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Text(_logs),
        ),
      ),
    );
  }

  Future<void> _getLogs() async {
    final String logs = await Logcat.execute();
    setState(() {
      _logs = logs;
    });
  }
}
