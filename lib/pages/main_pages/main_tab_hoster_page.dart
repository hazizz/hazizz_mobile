import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/pages/main_pages/main_grades_page.dart';
import 'package:mobile/pages/main_pages/main_tasks_page.dart';

import '../../hazizz_localizations.dart';
import '../../hazizz_theme.dart';
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
  void dispose() {

    _tabController.dispose();
    super.dispose();
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

            /*
            tasksTabPage
            ,
            gradesTabPage,
          schedulesTabPage
            */
          ]
      ),

      drawer: SizedBox(
        width: 270,
        child: Drawer(


          child: Column(
           // padding: EdgeInsets.zero,
            children: <Widget>[
              /*
              DrawerHeader(

                  child:
              ),

              */
              UserAccountsDrawerHeader(

                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                ),
                accountName: new Text("ASD"),
                accountEmail: new Text(""),

                currentAccountPicture: CircleAvatar(
                  child: new Text("oiasdasd"),
                ),
              ),


              ListTile(
                title: Text(locText(context, key: "my_tasks")),
                onTap: () {
                 // HazizzNotification.scheduleNotificationAlarmManager(DateTime.now());
                  Navigator.popAndPushNamed(context, "intro");

                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SimpleExample()),
                  );
                  */

                },
              ),
              ListTile(
                title: Text(locText(context, key: "groups")),
                onTap: () {
                  //Navigator.pop(context);
                  // Navigator.push(context,MaterialPageRoute(builder: (context) => GroupTabHosterPage(groupId: 2)));
                  Navigator.popAndPushNamed(context, "/groups");
                },
              ),


              Expanded(
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                 //   Divider(),
                    ListTile(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/settings");
                      },
                        leading: Icon(Icons.settings),
                        title: Text(locText(context, key: "settings"))),
                    Row(
                      children: [
                        Expanded(child:
                        ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text(locText(context, key: "textview_logout_drawer")),
                          onTap: () {
                            InfoCache.forgetMyUsername();
                            Navigator.pushReplacementNamed(
                                context, "login"
                            );
                          },
                        ),),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 10),
                          child: IconButton(
                            iconSize: 50,
                            icon: Icon(Icons.wb_sunny,
                            color: Colors.orangeAccent,),
                            onPressed: () async {
                              /*
                              DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
                              */


                            //  DynamicTheme.of(context).setThemeData(HazizzTheme.darkThemeData);
                              if(await HazizzTheme.isDark()) {
                                DynamicTheme.of(context).setThemeData(HazizzTheme.lightThemeData);
                                await HazizzTheme.setLight();
                              }else{
                                DynamicTheme.of(context).setThemeData(HazizzTheme.darkThemeData);
                                await HazizzTheme.setDark();
                              }

                            },
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
