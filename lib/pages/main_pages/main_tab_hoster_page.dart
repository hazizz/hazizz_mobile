import 'dart:async';

import 'dart:math' as math;
import 'dart:math';
import 'package:animator/animator.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/flush_bloc.dart';
import 'package:mobile/blocs/kreta/new_grade_bloc.dart';
import 'package:mobile/blocs/kreta/sessions_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/user_data_bloc.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/session_status_converter.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/app_state_restorer.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/managers/deep_link_receiver.dart';
import 'package:mobile/managers/version_handler.dart';
import 'package:mobile/pages/main_pages/main_grades_page.dart';
import 'package:mobile/pages/main_pages/main_tasks_page.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'main_schedules_page.dart';

class MainTabHosterPage extends StatefulWidget {

 // MainTabBlocs mainTabBlocs;

  MainTabHosterPage({Key key}) : super(key: key){
   // mainTabBlocs = MainTabBlocs();
  }

  @override
  _MainTabHosterPage createState() => _MainTabHosterPage();

}

class _MainTabHosterPage extends State<MainTabHosterPage> with TickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TabController _tabController;

  TasksPage tasksTabPage;
  SchedulesPage schedulesTabPage;
  GradesPage gradesTabPage;

  String displayName = "name";

  bool processingDeepLink = false;

  bool isDark = false;

  bool doEvent = false;

  PojoSession selectedKretaAccount = null;

  String selectedKretaAccountName = null;

  void _handleTabSelection() {
    if(_tabController.index == 2){
      NewGradesBloc().dispatch(DoesntHaveNewGradesEvent());
    }
    setState(() {

    });
  }

  AnimationController animationController;

  Animation animation;

  @override
  void initState() {
    selectedKretaAccount = SelectedSessionBloc().selectedSession;
    selectedKretaAccountName = selectedKretaAccount?.username;

    DeepLink.initUniLinks(context);

    InfoCache.getMyDisplayName().then(
            (value){
          HazizzLogger.printLog("getMyDisplayName: $value");

          setState(() {
            displayName = value;
          });
        }
    );

    VersionHandler.getLastRecordedVersion().then((String lastVersion){
      if(lastVersion != HazizzAppInfo().getInfo.version && false){
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            showNewFeatureDialog(context)
        );
      }
      VersionHandler.setLastRecordedVersion();
    });

    tasksTabPage = TasksPage();
    schedulesTabPage = SchedulesPage();
    gradesTabPage = GradesPage();

    _tabController = new TabController(length: 3, vsync: this, initialIndex: MainTabBlocs().initialIndex);

    _tabController.addListener(_handleTabSelection);

    HazizzTheme.isDark().then((value){
      setState(() {
        isDark = value;
      });
    });


    WidgetsBinding.instance.addPostFrameCallback((_) async =>
    await VersionHandler.check()
    );


    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 2300 + Random().nextInt(500) ),
    );

    animationController.forward();


    animation =  new Tween(
        begin: 0.0,
        end: 500.0//-math.pi/50,// -math.pi/6
    ).animate(new CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.elasticOut,
    ));

    if(Random().nextInt(5) == 1){
      doEvent = false;
    }

    AppStateRestorer.getShouldReloadTaskMaker().then((bool should){
      if(should){
        AppStateRestorer.loadTaskState().then((TaskMakerAppState taskMakerAppState){
          if(taskMakerAppState != null){
            if(taskMakerAppState.taskMakerMode == TaskMakerMode.create){
              WidgetsBinding.instance.addPostFrameCallback((_){
                setState(() {
                  Navigator.pushNamed(context, "/createTask", arguments: taskMakerAppState);
                });
              });
            }else{
              WidgetsBinding.instance.addPostFrameCallback((_){
                setState(() {
                  Navigator.pushNamed(context, "/editTask", arguments: taskMakerAppState);
                });
              });
            }
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {

    DeepLink.dispose();
    _tabController.dispose();
    super.dispose();
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop(){
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(locText(context, key: "press_again_to_exit")),
        duration: Duration(seconds: 3),
      ));

      return Future.value(false);
    }
    return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: <Widget>[

            Scaffold(
              key: _scaffoldKey,
              // backgroundColor: widget.color,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(FontAwesomeIcons.bars),
                    onPressed: () => _scaffoldKey.currentState.openDrawer()
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 4, ),
                  child: Text(locText(context, key: "hazizz"), style: TextStyle(fontWeight: FontWeight.w700, fontFamily: "Nunito", fontSize: 21),),
                ),

                bottom: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: tasksTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.bookOpen),),
                      Tab(text: schedulesTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.calendarAlt)),
                      Tab(text: gradesTabPage.getTabName(context), icon:
                      Stack(
                        children: <Widget>[
                          Center(child: Icon(FontAwesomeIcons.listOl)),

                          BlocBuilder(
                            bloc: NewGradesBloc(),
                            builder: (context, state){
                              if(state is HasNewGradesState){
                                return Positioned(
                                    top: 0, right: 27,
                                    child: Transform.translate(
                                      offset: const Offset(0.0, -6.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4, right: 4),
                                          child: Text(" ", style: TextStyle(fontSize: 8),),
                                        ),


                                        color: Colors.red,
                                      ),
                                    )
                                );
                              }
                              return Container();
                            },
                          )
                        ],
                      ),
                      ),
                      /*
            GestureDetector(
                onLongPress: (){
                  HazizzLogger.printLog("log: long press");
                },
                child: Tab(text: tasksTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.bookOpen),)
              ),
              GestureDetector(
                onLongPress: (){
                  HazizzLogger.printLog("log: long press");
                },
                child: Tab(text: schedulesTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.calendarAlt)),
              ),
              GestureDetector(
                onLongPress: (){
                  HazizzLogger.printLog("log: long press");
                },
                child: Tab(text: gradesTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.listOl)),
              ),
              */
                      // Tab(text: SchedulesPage.tabName),//, icon: Icon(Icons.scatter_plot)),
                      //, icon: Icon(Icons.group))
                    ]
                ),
              ),
              body: BlocListener(
                bloc: FlushBloc(),
                listener: (context, state){
                  if(state is FlushNoConnectionState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showNoConnectionFlushBar(context)
                    );
                  }else if(state is FlushKretaUnavailableState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showKretaUnavailableFlushBar(context)
                    );
                  }else if(state is FlushServerUnavailableState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showServerUnavailableFlushBar(context)
                    );
                  }

                  else if(state is FlushGatewayServerUnavailableState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showGatewayServerUnavailableFlushBar(context)
                    );
                  }else if(state is FlushAuthServerUnavailableState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showAuthServerUnavailableFlushBar(context)
                    );
                  }else if(state is FlushHazizzServerUnavailableState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showHazizzServerUnavailableFlushBar(context)
                    );
                  }else if(state is FlushTheraServerUnavailableState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showTheraServerUnavailableFlushBar(context)
                    );
                  }else if(state is FlushSessionFailState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showSessionFailFlushBar(context)
                    );
                  }
                },
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      tasksTabPage,
                      schedulesTabPage,
                      gradesTabPage
                    ]
                ),
              ),
              drawer: SizedBox(
                width: 270,
                child: Drawer(


                  child: Column(
                    children: <Widget>[
                      UserAccountsDrawerHeader(

                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                        ),
                        accountName: BlocBuilder(
                          bloc: UserDataBlocs().userDataBloc,
                          builder: (context, state){
                            if(UserDataBlocs().userDataBloc.myUserData != null) {
                              return Text(
                                UserDataBlocs().userDataBloc.myUserData.displayName,
                                style: TextStyle(fontSize: 18, fontFamily: "Nunito", fontWeight: FontWeight.w700),);
                            }
                            return Text(locText(context, key: "loading"), style: TextStyle(fontSize: 18),);


                          },
                        ),
                        accountEmail: BlocBuilder(
                          bloc: SelectedSessionBloc(),
                          builder: (_, state){
                            Text hardCodeless(String text){
                              return Text(text, style: TextStyle(fontSize: 16, fontFamily: "Nunito", fontWeight: FontWeight.w600), );
                            }
                            if(state is SelectedSessionFineState){
                              return hardCodeless("${locText(context, key: "kreta_account")}: ${state.session.username}");

                            }
                            return hardCodeless(locText(context, key: "not_logged_in_to_kreta_account"));
                          },
                        ),

                        currentAccountPicture: BlocBuilder(
                          bloc: UserDataBlocs().pictureBloc,
                          builder: (context, state){

                            if(UserDataBlocs().pictureBloc.profilePictureBytes != null){
                              Image img = Image.memory(UserDataBlocs().pictureBloc.profilePictureBytes);

                              return CircleAvatar(
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: img.image,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: new BorderRadius.all(const Radius.circular(80.0)),
                                    ),
                                  )
                              );
                            }


                            return CircleAvatar(
                              child: new Text(locText(context, key: "loading")),
                            );
                          },
                        ),

                      ),

                      Hero(
                        tag: "group",
                        child: ListTile(
                          leading: Icon(FontAwesomeIcons.users),

                          title: Text(locText(context, key: "my_groups")),
                          onTap: () {
                            //Navigator.pop(context);
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => GroupTabHosterPage(groupId: 2)));
                            Navigator.popAndPushNamed(context, "/groups");
                          },
                        ),
                      ),

                      ListTile(
                        leading: Icon(FontAwesomeIcons.tasks),
                        title: Text(locText(context, key: "task_calendar")),
                        onTap: () {
                          Navigator.popAndPushNamed(context, "/calendarTasks");
                        },
                      ),

                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 6, right: 8.0),
                            child: Text(locText(context, key: "kreta")),
                          ),
                          Expanded(child: Divider())
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: BlocBuilder(
                                bloc: SessionsBloc(),
                                builder: (context, state){

                                  List<PojoSession> sessions = [];

                                  for(PojoSession s in SessionsBloc().sessions){
                                    print("öö99: ${s.id}: ${s.username}");
                                    for(int i = 0; i< sessions.length; i++ ){
                                      PojoSession s2 = sessions[i];
                                      if(s2.username == s.username){
                                        if(getSessionStatusRank(s.status) < getSessionStatusRank(s2.status)){
                                          sessions[i] = s2;
                                          break;
                                        }
                                      }
                                    }
                                    sessions.add(s);

                                    /*
                                    bool found = false;
                                    for(int i = 0; i< SessionsBloc().sessions.length; i++ ){
                                      if(s.username == SessionsBloc().sessions[i].username){
                                        found = true;
                                        if(SessionsBloc().sessions[i].status == "ACTIVE"
                                        && s.status != "ACTIVE "){
                                          sessions.add(s);
                                          break;
                                        }
                                      }
                                    }
                                    if(!found){
                                      sessions.add(s);
                                    }
                                    */


                                  }

                                  List<DropdownMenuItem> items = [];

                                  for(PojoSession s in sessions){
                                    //  if(selectedKretaAccount == null || s.username != selectedKretaAccount.username){
                                    print("MÓÓÓÓ");

                                    if(getSessionStatusRank(s.status) > 0){
                                      items.add(DropdownMenuItem(child: Text(s.username, style: TextStyle(color: Colors.red),), value: s.username,));
                                    }else{
                                      items.add(DropdownMenuItem(child: Text(s.username), value: s.username,));
                                    }
                                    if(selectedKretaAccount?.username == s.username){

                                      selectedKretaAccount = s;
                                      selectedKretaAccountName = s.username;
                                    }
                                    //  }
                                  }

                                  items.forEach((item) => print("opo111: ${item.value}"));
                                  print("opo222: ${selectedKretaAccount?.username}");
                                  print("opo333: ${items.where((item) => item.value == selectedKretaAccountName).length == 1}");


                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: DropdownButton(
                                      value: selectedKretaAccountName,
                                      onChanged: (item){
                                        if(item =="add Kréta account"){
                                          Navigator.of(context).pushNamed("/kreta/login");
                                        }else{
                                          setState(() {
                                            selectedKretaAccountName = item;
                                            print("uff: ${selectedKretaAccountName}");
                                            for(PojoSession s in sessions){
                                              if(s.username == selectedKretaAccountName){

                                                if(s.status != "ACTIVE"){
                                                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                                                      Navigator.pushNamed(context, "/kreta/login/auth", arguments: s)
                                                  );
                                                }

                                                selectedKretaAccount = s;
                                                print("uff2: ${selectedKretaAccount.username}");

                                                SelectedSessionBloc().dispatch(SelectedSessionSetEvent(s));
                                                break;
                                              }
                                            }
                                          });
                                        }
                                      },
                                      items: items
                                    ),
                                  );


                                  /*
                                  for(PojoSession s in SessionsBloc().sessions){
                                    String username = s.username;

                                    if(sessions.every((element) => element.username == s.username)){
                                      continue;
                                    }

                                    if(s.status == "ACTIVE" ){
                                      sessions.add(s);
                                    }else{
                                      for(PojoSession s2 in SessionsBloc().sessions){
                                        if(){

                                        }
                                      }
                                    }
                                  }*/


                                  if(SessionsBloc().activeSessions != null && SessionsBloc().activeSessions.isNotEmpty){

                                    List<DropdownMenuItem> items = [];

                                    bool found = false;

                                    for(PojoSession s in SessionsBloc().activeSessions){
                                      //  if(selectedKretaAccount == null || s.username != selectedKretaAccount.username){
                                      items.add(DropdownMenuItem(child: Text(s.username), value: s.username,));
                                      if(selectedKretaAccount?.username == s.username){
                                        found = true;
                                        selectedKretaAccount = s;
                                        selectedKretaAccountName = s.username;
                                      }
                                      //  }
                                    }

                                    if(selectedKretaAccount == null){
                                      print("uffi pufi");
                                      selectedKretaAccount = SessionsBloc().activeSessions[0];
                                      selectedKretaAccountName = selectedKretaAccount.username;
                                    }

                                    if(items.isEmpty){
                                      items.add(DropdownMenuItem(child: Text("add Kréta account"), value: "add Kréta account",));
                                    }
                                    items.forEach((item) => print("opo111: ${item.value}"));
                                    print("opo222: ${selectedKretaAccount?.username}");
                                    print("opo333: ${items.where((item) => item.value == selectedKretaAccountName).length == 1}");


                                    /*
                                    if(!items.contains(selectedKretaAccountName)){
                                      print("uff this");
                                      selectedKretaAccountName = null;
                                    }
                                    */



                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: DropdownButton(
                                          value: selectedKretaAccountName,
                                          onChanged: (item){
                                            if(item =="add Kréta account"){
                                              Navigator.of(context).pushNamed("/kreta/login");
                                            }else{

                                              setState(() {
                                                selectedKretaAccountName = item;
                                                print("uff: ${selectedKretaAccountName}");
                                                for(PojoSession s in SessionsBloc().activeSessions){
                                                  if(s.username == selectedKretaAccountName){
                                                    selectedKretaAccount = s;
                                                    print("uff2: ${selectedKretaAccount.username}");

                                                    SelectedSessionBloc().dispatch(SelectedSessionSetEvent(s));
                                                    break;
                                                  }
                                                }
                                              });
                                            }
                                          },
                                          items: items
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.userEdit),
                                onPressed: (){
                                  // SessionsBloc().add(FetchData());
                                  Navigator.popAndPushNamed(context, "/kreta/accountSelector");
                                },
                              ),
                            ),

                          ],
                        ),
                      ),


                      /*
                  ListTile(
                    leading: Icon(FontAwesomeIcons.landmark),
                    title: Text(locText(context, key: "kreta_accounts")),
                    onTap: () {

                    },
                  ),
                  */

                      ListTile(
                        leading: Transform.rotate(
                            angle: math.pi,
                            child: Icon(FontAwesomeIcons.stickyNote)
                        ),
                        title: Text(locText(context, key: "kreta_notes")),
                        onTap: () {
                          Navigator.popAndPushNamed(context, "/kreta/notes");
                        },
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.percentage),
                        title: Text(locText(context, key: "kreta_grade_statistics")),
                        onTap: () {
                          Navigator.popAndPushNamed(context, "/kreta/statistics");
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
                                leading: Icon(FontAwesomeIcons.cog),
                                title: Text(locText(context, key: "settings"))
                            ),
                            Row(
                              children: [
                                Expanded(child:
                                ListTile(
                                  leading:  Transform.rotate(
                                      angle: -math.pi,
                                      child:  Icon(FontAwesomeIcons.signOutAlt)
                                  ),
                                  title: Text(locText(context, key: "textview_logout_drawer")),
                                  onTap: () async {
                                    await AppState.logout();
                                  },
                                ),),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4, left: 10),
                                  child: Builder(
                                      builder:(context){
                                        Icon icon = isDark?
                                        Icon(FontAwesomeIcons.solidSun, color: Colors.orangeAccent, size: 43):
                                        Icon(FontAwesomeIcons.solidMoon, color: Colors.black45, size: 39);

                                        return IconButton(
                                          iconSize: 50,
                                          icon: icon,
                                          onPressed: () async {
                                            if(await HazizzTheme.isDark()) {
                                              DynamicTheme.of(context).setThemeData(HazizzTheme.lightThemeData);
                                              await HazizzTheme.setLight();
                                              isDark = false;
                                            }else{
                                              DynamicTheme.of(context).setThemeData(HazizzTheme.darkThemeData);
                                              await HazizzTheme.setDark();
                                              isDark = true;
                                            }
                                          },
                                        );
                                      }
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
            ),
            Builder(
              builder: (context){
                if(doEvent){
                  return Animator(
                    tween: Tween<Offset>(begin: Offset(w*0.86, h+100),  end: Offset(w/2,-100)),
                    duration: Duration(seconds: 4),
                    cycles: 1,
                    builder: (anim){
                      return Transform.translate(
                        offset: anim.value,
                        child: Animator(
                          tween: Tween<double>(begin: -math.pi/6, end:  math.pi/6),
                          duration: Duration(milliseconds: 700),
                          cycles: 20,
                          builder: (anim2){
                            return Transform.rotate(
                                origin: Offset(0, -60),
                                angle: anim2.value,
                                child: Animator(
                                  //   tween: Tween<double>(begin: -40, end:  40),
                                  duration: Duration(milliseconds: 700),
                                  cycles: 20,
                                  builder: (anim3){
                                    return Transform.translate(
                                      offset: Offset(anim3.value, 0),

                                      child: Transform.scale(
                                        scale: 3,
                                        child:  Icon(FontAwesomeIcons.ghost, color: isDark ? Colors.white : Colors.grey),
                                      ),
                                    );
                                  },
                                )
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        )
    );
  }
}