import 'package:flutter/material.dart';
import 'package:hazizz_mobile/blocs/group_bloc.dart';


import 'group_members_page.dart';
import 'group_subjects_page.dart';
import 'group_tasks_page.dart';


class GroupTabHosterPage extends StatefulWidget {

  final int groupId;

  GroupTabHosterPage({Key key, @required this.groupId}) : super(key: key);

  @override
  _GroupTabHosterPage createState() => _GroupTabHosterPage(groupId: groupId);

}

class _GroupTabHosterPage extends State<GroupTabHosterPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  GroupTasksPage tasksTabPage;
  GroupSubjectsPage  subjectsTabPage;
  GroupMembersPage membersTabPage;


  GroupBlocs groupBlocs;
  _GroupTabHosterPage({@required groupId}){
    groupBlocs = new GroupBlocs(groupId_: groupId);

    tasksTabPage = GroupTasksPage(groupTasksBloc: groupBlocs.groupTasksBloc,);
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
        title: Text("Group: ${widget.groupId}"),
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: GroupTasksPage.tabName),
          Tab(text: GroupSubjectsPage.tabName),//, icon: Icon(Icons.scatter_plot)),
          Tab(text: GroupMembersPage.tabName),//, icon: Icon(Icons.group))

          ]),
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
