import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/welcome_manager.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:toast/toast.dart';


import '../../hazizz_localizations.dart';
import '../../hazizz_theme.dart';
import 'group_members_page.dart';
import 'group_subjects_page.dart';
import 'group_tasks_page.dart';

enum VisitorEnum{
  member,
  newComer,
  notNewComer,
}

class GroupTabHosterPage extends StatefulWidget {

  final PojoGroup group;

  VisitorEnum visitorEnum;


  GroupTabHosterPage({Key key, @required this.group, @required this.visitorEnum}) : super(key: key);


  @override
  _GroupTabHosterPage createState() => _GroupTabHosterPage();

}

class _GroupTabHosterPage extends State<GroupTabHosterPage> with SingleTickerProviderStateMixin{

  String title = "sad";

  TabController _tabController;

  GroupTasksPage tasksTabPage;
  GroupSubjectsPage  subjectsTabPage;
  GroupMembersPage membersTabPage;

  bool shownVisitorState = false;


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

    if(widget.visitorEnum == VisitorEnum.newComer){
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          showJoinedGroupDialog(context, group: widget.group)
      );
    }else if(widget.visitorEnum == VisitorEnum.notNewComer){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Toast.show(locText(context, key: "already_in_group"), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
       // showJoinedGroupDialog(context, group: widget.group);

   //     Toast(, context);
        /*
        var snackBar = SnackBar(content: Text(locText(context, key: "already_in_group")), duration: Duration(seconds: 3),);
        Scaffold.of(context).showSnackBar(snackBar);
        */
        }
      );
    }

    /*
    WelcomeManager.getMembers().then((isNewComer){
      if(isNewComer){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FeatureDiscovery.discoverFeatures(
            context,
            ['discover_group_invite'],
          );
        });
      }
    });
    */



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    title = "${locText(context, key: "group")}: ${widget.group.name}";
    return Scaffold(
     // backgroundColor: widget.color,
      appBar: AppBar(
        leading: HazizzBackButton(),
        title: Padding(
          padding: const EdgeInsets.only(top: 3.0, ),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontFamily: "Nunito", /*fontSize: 20*/),),
        ),
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: tasksTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.bookOpen),),
          Tab(text: subjectsTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.solidCalendarAlt)),//, icon: Icon(Icons.scatter_plot)),
          Tab(text: membersTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.users)),//, icon: Icon(Icons.group))

          ]
        ),
        actions: <Widget>[

          IconButton(
            icon: Icon(FontAwesomeIcons.userPlus),
            onPressed: (){
              showInviteDialog(context, group: groupBlocs.group);
            },
          ),
          /*
          DescribedFeatureOverlay(
              child: IconButton(
                icon: Icon(FontAwesomeIcons.userPlus),
                onPressed: (){
                  showInviteDialog(context, group: groupBlocs.group);
                },
              ),

              /*
              doAction: (func){
                func();
                print("CLICKED564: ${func}");
              },
              */
              featureId: 'discover_group_invite',
              icon: FontAwesomeIcons.userPlus,
              color: HazizzTheme.purple,
              contentLocation: ContentOrientation.above, // look at note
              title: locText(context, key: "discover_title_group_invite"),
              description: locText(context, key: "discover_description_group_invite")
          ),
          */
        ],
      ),

      body:
        Stack(
          children: <Widget>[
            TabBarView(
                controller: _tabController,
                children: [
                  tasksTabPage,
                  subjectsTabPage,
                  membersTabPage
                ]
            ),
            /*
            Builder(
              builder: (context){
                print("GOT HEREEEE0: ");

                if(!shownVisitorState){
                  if(widget.visitorEnum == VisitorEnum.newComer){
                    print("GOT HEREEEE1");
                  //  Toast.show("Welcome to new group", context, duration: 1);
                    showJoinedGroupDialog(context, group: widget.group);

                  }else if(widget.visitorEnum == VisitorEnum.notNewComer){
                    print("GOT HEREEEE2");
                  //  showJoinedGroupDialog(context, group: widget.group);
                    SchedulerBinding.instance.addPostFrameCallback((_) =>
                        showJoinedGroupDialog(context, group: widget.group)

                    );

                  //  SnackBar(content: Text("You are already a member of this group"));
                   // Toast.show("You are already a member of this group", context, duration: 1);
                  }


                  SchedulerBinding.instance.addPostFrameCallback((_) =>
                      setState(() {
                        shownVisitorState = true;
                      })
                  );

                }
                return Container();

              },
            )
            */
          ],
        )
    );
  }
}
