import 'dart:async';

import 'dart:math' as math;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/UserDataBloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/cache_manager.dart';
import 'package:mobile/pages/main_pages/main_grades_page.dart';
import 'package:mobile/pages/main_pages/main_tasks_page.dart';
import 'package:toast/toast.dart';
import 'package:uni_links/uni_links.dart';

import '../../hazizz_localizations.dart';
import '../../hazizz_response.dart';
import '../../hazizz_theme.dart';
import '../../request_sender.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  TabController _tabController;

  TasksPage tasksTabPage;
  SchedulesPage schedulesTabPage;
  GradesPage gradesTabPage;

  String displayName = "name";

  bool processingDeepLink = false;

  bool isDark = false;

  void _handleTabSelection() {
    setState(() {

    });
  }

  void onLinkReceived(Uri deepLink) async{

    print("DEEP LINK RECEIVED: ${deepLink.toString()}");
    if (deepLink != null) {
      setState(() {
        setState(() {
          processingDeepLink = true;
        });
      });
      String str_groupId = deepLink.queryParameters["group"];

      int groupId = int.parse(str_groupId);
      if(groupId != null){
        await showSureToJoinGroupDialog(context, groupId: groupId);
        /*
        HazizzResponse hazizzResponse = await RequestSender().getResponse(RetrieveGroup.withoutMe(p_groupId: groupId));
        if(hazizzResponse.isSuccessful){
          PojoGroupWithoutMe groupWithoutMe = hazizzResponse.convertedData;
          if(groupWithoutMe != null){
            print("GROUPCOUNT: ${ groupWithoutMe.userCount}, ${ groupWithoutMe.userCountWithoutMe}");
            if(groupWithoutMe.userCount == groupWithoutMe.userCountWithoutMe){
              Navigator.pushNamed(context, "/group/groupId/newComer", arguments: groupWithoutMe);

            }else{
              Navigator.pushNamed(context, "/group/groupId/notNewComer", arguments: groupWithoutMe);
            }
            setState(() {
              processingDeepLink = false;
            });
          }else{
            setState(() {
              processingDeepLink = false;
            });
          }
        }else{
          setState(() {
            processingDeepLink = false;
          });
        }
        */
        
      }else{
        setState(() {
          processingDeepLink = false;
        });
      }
    }
  }


  /*
  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    onLinkReceived(deepLink);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          onLinkReceived(deepLink);
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );
  }
  */

  StreamSubscription _sub;

  Future<Null> initUniLinks() async {
    Uri initialUri = await getInitialUri();


    onLinkReceived(initialUri);
    // Attach a listener to the stream
    _sub = getUriLinksStream().listen((Uri uri) {
      onLinkReceived(uri);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }


  @override
  Future initState() {

  //  initDynamicLinks();
    initUniLinks();

    InfoCache.getMyDisplayName().then(
      (value){
        print("log: getMyDisplayName: $value");

        setState(() {
          displayName = value;
        });
      }
    );


    tasksTabPage = TasksPage();
    schedulesTabPage = SchedulesPage();
    gradesTabPage = GradesPage();

    _tabController = new TabController(length: 3, vsync: this, initialIndex: widget.mainTabBlocs.initialIndex);

    _tabController.addListener(_handleTabSelection);


    HazizzTheme.isDark().then((value){
      setState(() {
        isDark = value;
      });
    });





    super.initState();
  }

  @override
  void dispose() {

    _sub.cancel();
    _tabController.dispose();
    super.dispose();
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop(){
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show(locText(context, key: "press_again_to_exit"), context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return Future.value(false);
    }
    return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          // backgroundColor: widget.color,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.bars),
              onPressed: () => _scaffoldKey.currentState.openDrawer()
            ),
            title: Text(locText(context, key: "hazizz")),

            bottom: TabBar(controller: _tabController, tabs: [
            Tab(text: tasksTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.bookOpen),),
            Tab(text: schedulesTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.calendarAlt)),
              Tab(text: gradesTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.listOl)),

            /*
            GestureDetector(
                onLongPress: (){
                  print("log: long press");
                },
                child: Tab(text: tasksTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.bookOpen),)
              ),
              GestureDetector(
                onLongPress: (){
                  print("log: long press");
                },
                child: Tab(text: schedulesTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.calendarAlt)),
              ),
              GestureDetector(
                onLongPress: (){
                  print("log: long press");
                },
                child: Tab(text: gradesTabPage.getTabName(context), icon: Icon(FontAwesomeIcons.listOl)),
              ),
              */
              // Tab(text: SchedulesPage.tabName),//, icon: Icon(Icons.scatter_plot)),
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
                    accountEmail: new Text(""),

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



                  ListTile(
                    title: Text(locText(context, key: "my_tasks")),
                    onTap: () async {
                      Navigator.popAndPushNamed(context, "intro");

                      /*
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SimpleExample()),
                      );
                       */

                    },
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
                    leading: Icon(FontAwesomeIcons.landmark),
                    title: Text(locText(context, key: "kreta_accounts")),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/kreta/accountSelector");
                    },
                  ),


                  Expanded(
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                     //   Divider(),
                        Hero(
                          tag: "settings",
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/settings");
                            },
                              leading: Icon(FontAwesomeIcons.cog),
                              title: Text(locText(context, key: "settings"))),
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
                              onTap: () {

                                AppState.logout();
                                /*
                                AppState.logOutProcedure();


                                Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                                */
                              },
                            ),),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0, left: 10),
                              child: Builder(
                                builder:(context){
                                  Icon icon = isDark?
                                    Icon(FontAwesomeIcons.solidSun, color: Colors.orangeAccent,):
                                    Icon(FontAwesomeIcons.solidMoon, color: Colors.black45, size: 43);

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
      );
  }
}
