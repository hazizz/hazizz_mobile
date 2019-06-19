import 'package:flutter/material.dart';
import 'package:hazizz_mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:hazizz_mobile/pages/main_pages/main_tasks_page.dart';


class MainTabHosterPage extends StatefulWidget {


  MainTabHosterPage({Key key}) : super(key: key);

  @override
  _MainTabHosterPage createState() => _MainTabHosterPage();

}

class _MainTabHosterPage extends State<MainTabHosterPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  TasksPage tasksTabPage;
  TasksPage schedulesTabPage;
  TasksPage gradesTabPage;

  MainTabBlocs mainTabBlocs;
  _MainTabHosterPage(){
    mainTabBlocs = new MainTabBlocs();

    tasksTabPage = TasksPage(groupTasksBloc: mainTabBlocs.tasksBloc);
    schedulesTabPage = SchedulesPage(groupSubjectsBloc: mainTabBlocs.schedulesBloc);
    gradesTabPage = GradesPage(groupMembersBloc: mainTabBlocs.gradesBloc);
  }

  void _handleTabSelection() {
    setState(() {

    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: widget.color,
      appBar: AppBar(
        flexibleSpace: SafeArea(
            child: TabBar(controller: _tabController, tabs: [
              Tab(text: TasksPage.tabName),
              Tab(text: SchedulesPage.tabName),//, icon: Icon(Icons.scatter_plot)),
              Tab(text: GradesPage.tabName),//, icon: Icon(Icons.group))
            ])
        ),
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
    );
  }
}
