import 'package:flutter/material.dart';
import 'package:flutter_hazizz/pages/EditTaskPage.dart';
import 'package:flutter_hazizz/pages/LoginPage.dart';
import 'package:flutter_hazizz/pages/TaskPage.dart';
import 'HazizzDrawer.dart';
import 'Page1.dart';
import 'PlaceHolderWidget.dart';
import 'RequestSender.dart';
import 'managers/TokenManager.dart';

Widget _startPage;

void main() async{
  if(await TokenManager.hasToken()){
    _startPage = MyHomePage(title: "title",);
  }else{
    _startPage = LoginPage();
  }
 // _startPage = EditTaskPage();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Hazizz Demo',
      showPerformanceOverlay: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: _startPage, // MyHomePage(title: 'Hazizz Demo Home Page'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  final String title;
  final String title2 = "sa";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  int _counter = 0;
  int _selectedIndex = 0;

  TabController _tabController;

  Widget drawer = new HazizzDrawer();

  final List<Widget> _children = [new TaskPage(), PlaceholderWidget(color: Colors.red, name1: "222", text1: Text("222"),)];


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
   // return MainPersistentTabBar([Icon(Icons.directions_car), Icon(Icons.directions_car)]);
    return Scaffold(

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _children[_selectedIndex],
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
       /* TabBarView(
              controller: _tabController,
              children: [
                Icon(Icons.directions_car),
                Icon(Icons.directions_transit),
              ]
        ),
        */
        /*Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),

      ),

      */


      floatingActionButton:
        FloatingActionButton(
          heroTag: "hero_task_edit",
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => EditTaskPage()));
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: UserAccountsDrawerHeader(
                  accountName: new Text("ASD"),
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
                Navigator.pop(context);
               // Page1();
                Navigator.push(context,MaterialPageRoute(builder: (context) => Page1(title: "TITLE",)));

              },
            ),
            ListTile(
              title: Text('My Tasks'),
              onTap: () {
                // Update the state of the app
                // ...
               // name = "Alaptalan";
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
