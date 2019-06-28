import 'package:flutter/material.dart';
import 'HazizzDrawer.dart';

class MainPersistentTabBar extends StatelessWidget {

  List<Widget> pages = new List(2);

  MainPersistentTabBar(this.pages){

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car), text: "Non persistent", ),
                Tab(icon: Icon(Icons.directions_transit), text: "Persistent"),
            ],
          ),
          title: Text('Persistent Tab Demo'),
        ),
        body: TabBarView(
          children: pages,

        ),
        drawer: HazizzDrawer(),
      ),
    );
  }
}