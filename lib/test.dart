import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Hero demo'),
      ),
      body: new Align(
        alignment: FractionalOffset.center,
        child: new Card(
          child: new Hero(
            tag: 'developer-hero',
            child: new Container(
              width: 300.0,
              height: 300.0,
              child: new FlutterLogo(),
            ),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.developer_mode),
        onPressed: () {

        },
      ),
    );
  }
}
