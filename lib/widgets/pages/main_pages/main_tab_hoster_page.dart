import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'package:animator/animator.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/new_grade_bloc.dart';
import 'package:mobile/blocs/kreta/sessions_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/blocs/other/flush_bloc.dart';
import 'package:mobile/blocs/other/user_data_bloc.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/tasks/task_maker_blocs.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/custom/hazizz_app_info.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/custom/session_status_converter.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/app_state_restorer.dart';
import 'package:mobile/managers/preference_service.dart';
import 'package:mobile/services/version_handler.dart';
import 'package:mobile/storage/cache_manager.dart';
import 'package:mobile/managers/deep_link_controller.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/tab_widget.dart';
import 'main_grades_page.dart';
import 'main_schedules_page.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

import 'main_tasks_page.dart';
import 'package:mobile/managers/firebase_analytics.dart';

class MainTabHosterPage extends StatefulWidget {

  MainTabHosterPage({Key key}) : super(key: key);

  @override
  _MainTabHosterPage createState() => _MainTabHosterPage();

}

class _MainTabHosterPage extends State<MainTabHosterPage> with TickerProviderStateMixin, RouteAware{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TabController _tabController;

  TabWidget tasksTabPage;
  TabWidget schedulesTabPage;
  TabWidget gradesTabPage;

  String displayName = "name";

  bool processingDeepLink = false;

  bool isDark = false;

  bool doEvent = false;

  PojoSession selectedKretaAccount;

  String selectedKretaAccountName;

  static String currentTabName;

  void mapTabIndexToTabName(int index){
    switch(index){
      case 0:
        currentTabName = tasksTabPage.tabName;
        break;
      case 1:
        currentTabName = schedulesTabPage.tabName;
        break;
      case 2:
        currentTabName = gradesTabPage.tabName;
        break;
    }
  }

  void _handleTabSelection() {
    mapTabIndexToTabName(_tabController.index);
    _sendCurrentTabToAnalytics();
    if(_tabController.index == 2){
      NewGradesBloc().add(DoesntHaveNewGradesEvent());
    }
    FirebaseAnalyticsManager.logMainTabSelected(_tabController.index);
    setState(() {

    });
  }

  AnimationController animationController;

  Animation animation;

  @override
  void initState() {

    if(currentTabName == null){
      PreferenceService.getStartPageIndex().then(
      (int pageIndex){
        mapTabIndexToTabName(pageIndex);
      });
    }

    selectedKretaAccount = SelectedSessionBloc().selectedSession;
    selectedKretaAccountName = selectedKretaAccount?.username;

    DeepLinkController.initUniLinks(context);

    CacheManager.getMyDisplayName().then(
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
    
    DateTime now = DateTime.now();
    
    CacheManager.seenGiveaway().then((bool haveSeen){
      if(!haveSeen && now.isBefore(DateTime(2020, 04, 17, 23, 59))){
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            showGiveawayDialog(context)
        );
      }
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAnalyticsManager.observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    FirebaseAnalyticsManager.observer.unsubscribe(this);
    DeepLinkController.dispose();
    _tabController.dispose();
    animationController.dispose();
    super.dispose();
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop(){
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > 2.seconds) {
      currentBackPressTime = now;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(localize(context, key: "press_again_to_exit")),
        duration: 3.seconds,
      ));

      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    FirebaseAnalyticsManager.observer.analytics.setCurrentScreen(
      screenName: currentTabName ?? "tab name not set",
    );
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
                  child: Text(localize(context, key: "hazizz"), style: TextStyle(fontWeight: FontWeight.w700, fontFamily: "Nunito", fontSize: 21),),
                ),

                bottom: TabBar(

                    controller: _tabController,
                    tabs: [
                      Tab(text: tasksTabPage.getUIName(context), icon: Icon(FontAwesomeIcons.bookOpen),),
                      Tab(text: schedulesTabPage.getUIName(context), icon: Icon(FontAwesomeIcons.calendarAlt)),
                      Tab(text: gradesTabPage.getUIName(context), icon:
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
                  if(state is FlushFlutterErrorState){
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        showFlutterErrorFlushBar(context, flutterErrorDetails: state.flutterErrorDetails)
                    );
                  }
                  else if(state is FlushNoConnectionState){
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
                                UserDataBlocs().userDataBloc.myUserData.username,
                                style: TextStyle(fontSize: 18, fontFamily: "Nunito", fontWeight: FontWeight.w700),);
                            }
                            return Text(localize(context, key: "loading"), style: TextStyle(fontSize: 18),);


                          },
                        ),
                        accountEmail: BlocBuilder(
                          bloc: SelectedSessionBloc(),
                          builder: (_, state){
                            Text unHardCodeify(String text){
                              return Text(text, style: TextStyle(fontSize: 16, fontFamily: "Nunito", fontWeight: FontWeight.w600), );
                            }
                            if(state is SelectedSessionFineState){
                              return unHardCodeify("${localize(context, key: "kreta_account")}: ${state.session.username}");

                            }
                            return unHardCodeify(localize(context, key: "not_logged_in_to_kreta_account"));
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
                              child: new Text(localize(context, key: "loading")),
                            );
                          },
                        ),

                      ),

                      Hero(
                        tag: "group",
                        child: ListTile(
                          leading: Icon(FontAwesomeIcons.users),

                          title: Text("my_groups".localize(context)),
                          onTap: () {
                            //Navigator.pop(context);
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => GroupTabHosterPage(groupId: 2)));
                            Navigator.popAndPushNamed(context, "/groups");
                          },
                        ),
                      ),

                      ListTile(
                        leading: Icon(FontAwesomeIcons.tasks),
                        title: Text(localize(context, key: "task_calendar")),
                        onTap: () {
                          Navigator.popAndPushNamed(context, "/calendarTasks");
                        },
                      ),

                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 6, right: 8.0),
                            child: Text(localize(context, key: "kreta")),
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
                              child: BlocConsumer(
                                bloc: SessionsBloc(),
                                listener: (context, state){
                                  if(state is SelectedSessionFineState){
                                    setState(() {
                                      selectedKretaAccountName = state.session.username;
                                    });
                                  }
                                },
                                builder: (context, state){
                                  List<PojoSession> sessions = [];
                                  for(PojoSession s in SessionsBloc().sessions){
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
                                  }

                                  List<DropdownMenuItem> items = [];

                                  for(PojoSession s in sessions){
                                    //  if(selectedKretaAccount == null || s.username != selectedKretaAccount.username){
                                    if(getSessionStatusRank(s.status) > 0){
                                      if(s.status != "INVALID_CREDENTIALS"){
                                        items.add(DropdownMenuItem(child: Text(s.username, style: TextStyle(color: Colors.red),), value: s.username,));
                                      }
                                    }else{
                                      items.add(DropdownMenuItem(child: Text(s.username), value: s.username,));
                                    }
                                    if(selectedKretaAccount?.username == s.username){

                                      selectedKretaAccount = s;
                                      selectedKretaAccountName = s.username;
                                    }
                                  }

                                  print("Items in Dropdown widget:");
                                  items.forEach((item) => print(item.value));
                                  print("Items selected in Dropdown widget: ${selectedKretaAccount?.username}");
                                  print("items.where((item) => item.value == selectedKretaAccountName).length == 1: ${items.where((item) => item.value == selectedKretaAccountName).length == 1}");

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
                                            for(PojoSession s in sessions){
                                              if(s.username == selectedKretaAccountName){

                                                HazizzLogger.printLog("Hé te paraszth: " + s.status);
                                                if(s.status != "ACTIVE"){
                                                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                    var reAuthSuccess = await Navigator.pushNamed(context, "/kreta/login/auth", arguments: s);

                                                    if(reAuthSuccess){
                                                      SelectedSessionBloc().add(SelectedSessionSetEvent(s));
                                                    }else{
                                                      setState(() {
                                                        selectedKretaAccountName = SelectedSessionBloc().selectedSession.username;
                                                      });
                                                    }
                                                  });
                                                  break;
                                                }else{
                                                  SelectedSessionBloc().add(SelectedSessionSetEvent(s));
                                                  selectedKretaAccount = s;
                                                }


                                                print("Selected Kreta account is: ${selectedKretaAccount.username}");

                                               // SelectedSessionBloc().add(SelectedSessionSetEvent(s));
                                              //  break;
                                              }
                                            }
                                          });
                                        }
                                      },
                                      items: items
                                    ),
                                  );
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.userEdit),
                                onPressed: (){
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
                        title: Text(localize(context, key: "kreta_notes")),
                        onTap: () {
                          Navigator.popAndPushNamed(context, "/kreta/notes");
                        },
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.percentage),
                        title: Text(localize(context, key: "kreta_grade_statistics")),
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
                                title: Text(localize(context, key: "settings"))
                            ),
                            Row(
                              children: [
                                Expanded(child:
                                ListTile(
                                  leading:  Transform.rotate(
                                      angle: -math.pi,
                                      child:  Icon(FontAwesomeIcons.signOutAlt)
                                  ),
                                  title: Text(localize(context, key: "textview_logout_drawer")),
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
                    duration: 4.seconds,
                    cycles: 1,
                    builder: (anim){
                      return Transform.translate(
                        offset: anim.value,
                        child: Animator(
                          tween: Tween<double>(begin: -math.pi/6, end:  math.pi/6),
                          duration: 700.milliseconds,
                          cycles: 20,
                          builder: (anim2){
                            return Transform.rotate(
                                origin: Offset(0, -60),
                                angle: anim2.value,
                                child: Animator(
                                  duration: 700.milliseconds,
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