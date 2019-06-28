//import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hazizz_mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:hazizz_mobile/managers/cache_manager.dart';
import 'package:hazizz_mobile/managers/preference_services.dart';
import 'package:hazizz_mobile/notification/notification.dart';
import 'package:hazizz_mobile/pages/group_pages/group_tab_hoster_page.dart';
import 'package:hazizz_mobile/pages/main_pages/main_grades_page.dart';
import 'package:hazizz_mobile/pages/main_pages/main_tasks_page.dart';

import '../../Page1.dart';
import '../../hazizz_localization.dart';
import '../../hazizz_localizations.dart';
import '../kreta_login_page.dart';
import 'main_schedules_page.dart';


class MainTabHosterPage extends StatefulWidget {

  MainTabBlocs mainTabBlocs;

  MainTabHosterPage({Key key}) : super(key: key){
    mainTabBlocs = MainTabBlocs();
  }

  @override
  _MainTabHosterPage createState() => _MainTabHosterPage();

}

class _MainTabHosterPage extends State<MainTabHosterPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  TasksPage tasksTabPage;
  SchedulesPage schedulesTabPage;
  GradesPage gradesTabPage;


  void _handleTabSelection() {
    setState(() {

    });
  }

  @override
  void initState() {

    tasksTabPage = TasksPage(tasksBloc: widget.mainTabBlocs.tasksBloc);
    schedulesTabPage = SchedulesPage(schedulesBloc: widget.mainTabBlocs.schedulesBloc);
    gradesTabPage = GradesPage(gradesBloc: widget.mainTabBlocs.gradesBloc);

    _tabController = new TabController(length: 3, vsync: this, initialIndex: widget.mainTabBlocs.initialIndex);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: widget.color,
      appBar: AppBar(
        title: Text(locText(context, key: "hazizz")),

        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: tasksTabPage.getTabName(context)),
          // Tab(text: SchedulesPage.tabName),//, icon: Icon(Icons.scatter_plot)),
          Tab(text: schedulesTabPage.getTabName(context)),
          Tab(text: gradesTabPage.getTabName(context)),
          //, icon: Icon(Icons.group))
        ]),
      ),
      body:
      TabBarView(
          controller: _tabController,
          children: [
            tasksTabPage,
            schedulesTabPage,
            gradesTabPage
          ]
      ),

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
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Page1(title: "TITLE",)));
              },
            ),
            ListTile(
              title: Text('My Tasks'),
              onTap: () {
                HazizzNotification.scheduleNotificationAlarmManager();

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Groups'),
              onTap: () {
                //Navigator.pop(context);
                // Navigator.push(context,MaterialPageRoute(builder: (context) => GroupTabHosterPage(groupId: 2)));
                Navigator.popAndPushNamed(context, "/groups");
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
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/settings");
                              },
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
                                Navigator.pushReplacementNamed(
                                    context, "login");
                              },
                            ),

                          ],
                        )
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
