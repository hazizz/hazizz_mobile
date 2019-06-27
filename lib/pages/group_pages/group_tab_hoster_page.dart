import 'package:flutter/material.dart';
import 'package:hazizz_mobile/blocs/group_bloc.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';


import '../../hazizz_localizations.dart';
import 'group_members_page.dart';
import 'group_subjects_page.dart';
import 'group_tasks_page.dart';


class GroupTabHosterPage extends StatefulWidget {

  final PojoGroup group;


  GroupTabHosterPage({Key key, @required this.group}) : super(key: key);

  @override
  _GroupTabHosterPage createState() => _GroupTabHosterPage();

}

class _GroupTabHosterPage extends State<GroupTabHosterPage> with SingleTickerProviderStateMixin{

  String title = "sad";

  TabController _tabController;

  GroupTasksPage tasksTabPage;
  GroupSubjectsPage  subjectsTabPage;
  GroupMembersPage membersTabPage;


  GroupBlocs groupBlocs;


  void _handleTabSelection() {
    setState(() {

    });
  }

  @override
  void initState() {
    groupBlocs = new GroupBlocs();
    groupBlocs.newGroup(widget.group);

    tasksTabPage = GroupTasksPage(groupTasksBloc: groupBlocs.groupTasksBloc,);
    subjectsTabPage = GroupSubjectsPage(groupSubjectsBloc: groupBlocs.groupSubjectsBloc);
    membersTabPage = GroupMembersPage(groupMembersBloc: groupBlocs.groupMembersBloc);

    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    title = "${locText(context, key: "group")}: ${widget.group.name}";
    return Scaffold(
     // backgroundColor: widget.color,
      appBar: AppBar(
        title: Text(title),
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: tasksTabPage.getTabName(context)),
          Tab(text: subjectsTabPage.getTabName(context)),//, icon: Icon(Icons.scatter_plot)),
          Tab(text: membersTabPage.getTabName(context)),//, icon: Icon(Icons.group))

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
