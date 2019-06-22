import 'package:flutter/material.dart';
import 'package:hazizz_mobile/pages/LoginPage.dart';
import 'package:hazizz_mobile/pages/main_pages/main_tasks_page.dart';
import 'package:hazizz_mobile/pages/task_maker_page.dart';
import 'package:hazizz_mobile/route_generator.dart';
import 'HazizzDrawer.dart';
import 'Page1.dart';
import 'PlaceHolderWidget.dart';
import 'hazizz_theme.dart';
import 'managers/TokenManager.dart';
import 'managers/app_state_manager.dart';
import 'managers/cache_manager.dart';
import 'pages/group_pages/group_tab_hoster_page.dart';

Widget _startPage;
String _startPage2;
//RouteGenerator routeGenerator;

void main() async{

 // routeGenerator = await RouteGeneratorManager.get();

  if(await AppState.isLoggedIn()){
    _startPage = MyHomePage(title: "title",);
    _startPage2 = "/";
  }else{
    _startPage = LoginPage();
    _startPage2 = "login";
  }
 // _startPage = LoginPage();
 // _startPage2 = "login";
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){

    return MaterialApp(

      title: 'Hazizz Demo',
      showPerformanceOverlay: false,
      theme: HazizzTheme.lightThemeData,
     // home: _startPage,//MyHomePage(title: 'Hazizz Demo Home Page') //_startPage, // MyHomePage(title: 'Hazizz Demo Home Page'),
      initialRoute: _startPage2,
      onGenerateRoute: RouteGenerator.generateRoute,
    //  onGenerateRoute: routeGenerator.generateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);
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
  int _selectedIndex = 0;

  TabController _tabController;

  Widget drawer = new HazizzDrawer();

  final List<Widget> _children = [new TasksPage(), PlaceholderWidget(color: Colors.red, name1: "222", text1: Text("222"),)];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        title: Text(widget.title),
      ),
      body: _children[_selectedIndex],
       /* TabBarView(
              controller: _tabController,
              children: [
                Icon(Icons.directions_car),
                Icon(Icons.directions_transit),
              ]
        ),
        */

      floatingActionButton:
        FloatingActionButton(
          heroTag: "hero_task_edit",
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => TaskMakerPage.createMode()));
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Groups'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context) => GroupTabHosterPage(groupId: 2)));

              },
            ),

            Container(
              // This align moves the children to the bottom
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // This container holds all the children that will be aligned
                    // on the bottom and should not scroll with the above ListView
                    child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                                leading: Icon(Icons.settings),
                                title: Text('Settings')),
                            ListTile(
                                leading: Icon(Icons.help),
                                title: Text('Help and Feedback')),
                            ListTile(
                              leading: Icon(Icons.exit_to_app),
                              title: Text('Logout'),
                              onTap: () {
                                InfoCache.forgetMyUsername();
                                Navigator.pushReplacementNamed(context, "login");
                              },
                            ),

                          ],
                        )
                    )
                )
            )

            /*
            new Expanded(
              child: new Align(
                alignment: Alignment.bottomRight,
                child: ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "login");

                  },
                ),
              ),
            ),
            */

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
