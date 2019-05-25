// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'RequestSender.dart';
import 'GetTasksFromMe.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
/*
void main() => runApp(MyApp());
*/
/// This Widget is the main application widget.
class MyApp2 extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      showPerformanceOverlay: false,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Hazizz',
      style: optionStyle,
    ),
    Text(
      'Théra',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void processData(GetTasksFromMe){

  }

  T first<T>(List<T> ts) {
    // Do some initial work or error checking, then...
    T tmp = ts[0];
    // Do some additional checking or processing...




    return tmp;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('debug: oi');
        },
        backgroundColor: Color.fromARGB(200, 200, 200, 200),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: UserAccountsDrawerHeader(
                accountName: new Text("Erik"),
                accountEmail: new Text("email"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                      ? Colors.tealAccent[200]
                      : Colors.amber[300],
                  child: new Text("oiasdasd"),
                ),
              )
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('My Tasks'),
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Thera'),
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Hazizz'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_photo),
            title: Text('Thera'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[400],
        onTap: _onItemTapped,
      ),
    );

  }
}
