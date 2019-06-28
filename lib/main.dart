import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
<<<<<<< HEAD


import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobile/hazizz_localizations.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/main_pages/main_tab_hoster_page.dart';
import 'package:mobile/pages/main_pages/main_tasks_page.dart';
import 'package:mobile/pages/task_maker_page.dart';
import 'package:mobile/route_generator.dart';
=======
import 'package:flutter/material.dart';
import 'package:hazizz_mobile/hazizz_localizations.dart';
import 'package:hazizz_mobile/pages/LoginPage.dart';
import 'package:hazizz_mobile/pages/main_pages/main_tab_hoster_page.dart';
import 'package:hazizz_mobile/pages/main_pages/main_tasks_page.dart';
import 'package:hazizz_mobile/pages/task_maker_page.dart';
import 'package:hazizz_mobile/route_generator.dart';
>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc
import 'HazizzDrawer.dart';
import 'Page1.dart';
import 'PlaceHolderWidget.dart';
import 'blocs/main_tab_blocs/main_tab_blocs.dart';
import 'blocs/request_event.dart';
import 'hazizz_theme.dart';
import 'managers/app_state_manager.dart';
import 'managers/cache_manager.dart';
import 'pages/group_pages/group_tab_hoster_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';


Widget _startPage;
String _startPage2;

bool isLoggedIn = true;

//Locale locale;
//RouteGenerator routeGenerator;

MainTabBlocs mainTabBlocs = MainTabBlocs();


void main() async{


  await AndroidAlarmManager.initialize();

  if(!(await AppState.isLoggedIn())){
    isLoggedIn = false;
  }else{
    mainTabBlocs.initialize();
  }

<<<<<<< HEAD
  // locale = await getPreferredLocal();

  // _startPage = LoginPage();
  // _startPage2 = "login";
  // runApp(MyApp());
  runApp(MyApp());

}

class MyApp extends StatefulWidget{
  @override
  _MyApp createState() => _MyApp();
}

=======
 // locale = await getPreferredLocal();

 // _startPage = LoginPage();
 // _startPage2 = "login";
 // runApp(MyApp());
  runApp(MyApp());

}

class MyApp extends StatefulWidget{
  @override
  _MyApp createState() => _MyApp();
}

>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc
class _MyApp extends State<MyApp> {
  // This widget is the root of your application.

  Locale preferredLocale;

  bool timerWentOff = false;


  @override
  initState() {
    super.initState();

    getPreferredLocal().then((locale) {
      setState(() {
        this.preferredLocale = locale;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    // var data = EasyLocalizationProvider.of(context).data;
    timerWentOff = true;
    if(timerWentOff) {
      if(isLoggedIn){
        _startPage = MainTabHosterPage();
        _startPage2 = "/";
      }else{
        _startPage = LoginPage();
        _startPage2 = "login";
      }
      return MaterialApp(
        title: 'Hazizz Demo',
        showPerformanceOverlay: false,
        theme: HazizzTheme.lightThemeData,
        // home: _startPage,//MyHomePage(title: 'Hazizz Demo Home Page') //_startPage, // MyHomePage(title: 'Hazizz Demo Home Page'),
        initialRoute: _startPage2,
<<<<<<< HEAD
        //  home: _startPage,
=======
      //  home: _startPage,
>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc
        onGenerateRoute: RouteGenerator.generateRoute,
        localizationsDelegates: [
          HazizzLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          //app-specific localization
        ],
        supportedLocales: [Locale('en', "EN"), Locale('hu', "HU")],

        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          // Locale myLocale = Localizations.localeOf(context);
          if(preferredLocale != null) {
            return preferredLocale;
          }
          for(var supportedLocale in supportedLocales) {
            if(supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
      );
    }else{
<<<<<<< HEAD
      //  mainTabBlocs = MainTabBlocs();
      //  mainTabBlocs.tasksBloc.dispatch(FetchData());
      //   mainTabBlocs.schedulesBloc.dispatch(FetchData());
      // mainTabBlocs.gradesBloc.dispatch(FetchData());

      //   mainTabBlocs.tasksBloc.dispatch(FetchData());
      //   mainTabBlocs.schedulesBloc.dispatch(FetchData());
      //   mainTabBlocs.gradesBloc.dispatch(FetchData());
=======
    //  mainTabBlocs = MainTabBlocs();
    //  mainTabBlocs.tasksBloc.dispatch(FetchData());
   //   mainTabBlocs.schedulesBloc.dispatch(FetchData());
     // mainTabBlocs.gradesBloc.dispatch(FetchData());

   //   mainTabBlocs.tasksBloc.dispatch(FetchData());
   //   mainTabBlocs.schedulesBloc.dispatch(FetchData());
   //   mainTabBlocs.gradesBloc.dispatch(FetchData());
>>>>>>> 4c9d004c5a9e9c416ab5b26080cdb3e8a330b7fc


      Timer(Duration(seconds: 1), (){
        setState(() {
          timerWentOff = true;
        });
      });


      return Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child:Image.asset(
            'assets/images/Logo.png',
          ),
        ),
      );
    }
  }
}

/*

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
              //  Navigator.pop(context);
               // Navigator.push(context,MaterialPageRoute(builder: (context) => GroupTabHosterPage(groupId: 2)));

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

*/
