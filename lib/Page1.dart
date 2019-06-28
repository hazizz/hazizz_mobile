import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {

  Page1({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Page1 createState() => _Page1();
}


class _Page1 extends State<Page1> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.



        title: Text(widget.title),
      ),
      body: Text("hey"),
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.


    );
  }

}
