import 'package:flutter/material.dart';
import 'package:hazizz_mobile/blocs/group_bloc.dart';
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

  GroupBlocs groupBlocs;
  _MainTabHosterPage(){
    groupBlocs = new GroupBlocs(groupId_: groupId);

    tasksTabPage = TasksPage(groupTasksBloc: groupBlocs.groupTasksBloc,);
    subjectsTabPage = GroupSubjectsPage(groupSubjectsBloc: groupBlocs.groupSubjectsBloc);
    membersTabPage = GroupMembersPage(groupMembersBloc: groupBlocs.groupMembersBloc);
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
              Tab(text: GroupSubjectsPage.tabName),//, icon: Icon(Icons.scatter_plot)),
              Tab(text: GroupMembersPage.tabName),//, icon: Icon(Icons.group))

            ])
        ),
      ),

      body:
      TabBarView(
          controller: _tabController,
          children: [
            tasksTabPage,
            subjectsTabPage,
            membersTabPage
          ]
      ),
    );
  }
}
