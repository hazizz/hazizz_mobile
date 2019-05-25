import 'package:flutter/material.dart';
import 'main.dart';

class HazizzDrawer extends StatelessWidget{

  String name = "ALAP";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: UserAccountsDrawerHeader(
                accountName: new Text(name),
                accountEmail: new Text("email"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .platform == TargetPlatform.iOS
                      ? Colors.tealAccent[200]
                      : Colors.amber[300],
                  child: new Text("oiasdasd"),
                ),
              )
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              name = "Alaptalan";
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('My Tasks'),
            onTap: () {
              // Update the state of the app
              // ...
              name = "Alaptalan";
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
    );
  }
}
