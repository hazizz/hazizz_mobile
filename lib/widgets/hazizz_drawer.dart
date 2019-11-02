import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/kreta_notes_bloc.dart';
import 'package:mobile/blocs/kreta/selected_session_bloc.dart';
import 'package:mobile/blocs/kreta/sessions_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/blocs/other/user_data_bloc.dart';
import 'package:mobile/communication/pojos/PojoKretaNote.dart';
import 'package:mobile/communication/pojos/PojoSession.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'dart:math' as math;

class HazizzDrawer extends StatefulWidget {

  @override
  _HazizzDrawer createState() => _HazizzDrawer();
}

class _HazizzDrawer extends State<HazizzDrawer> {
  bool isDark = false;
  PojoSession selectedKretaAccount = null;

  @override
  void initState() {
    selectedKretaAccount = SelectedSessionBloc().selectedSession;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Drawer(


        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(

              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColorDark,
              ),
              accountName: BlocBuilder(
                bloc: UserDataBlocs().userDataBloc,
                builder: (context, state) {
                  if(UserDataBlocs().userDataBloc.myUserData != null) {
                    return Text(
                      UserDataBlocs().userDataBloc.myUserData.displayName,
                      style: TextStyle(fontSize: 18,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700),);
                  }
                  return Text(locText(context, key: "loading"),
                    style: TextStyle(fontSize: 18),);
                },
              ),
              accountEmail: BlocBuilder(
                bloc: SelectedSessionBloc(),
                builder: (_, state) {
                  Text hardCodeless(String text) {
                    return Text(text, style: TextStyle(fontSize: 16,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600),);
                  }
                  if(state is SelectedSessionFineState) {
                    return hardCodeless(
                        "${locText(context, key: "kreta_account")}: ${state
                            .session.username}");
                  }
                  return hardCodeless(
                      locText(context, key: "not_logged_in_to_kreta_account"));
                },
              ),

              currentAccountPicture: BlocBuilder(
                bloc: UserDataBlocs().pictureBloc,
                builder: (context, state) {
                  if(UserDataBlocs().pictureBloc.profilePictureBytes != null) {
                    Image img = Image.memory(
                        UserDataBlocs().pictureBloc.profilePictureBytes);

                    return CircleAvatar(
                        child: Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: img.image,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(80.0)),
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

            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.userEdit),
                    onPressed: () {
                      // SessionsBloc().add(FetchData());
                      Navigator.popAndPushNamed(
                          context, "/kreta/accountSelector");
                    },
                  ),
                ),
                BlocBuilder(
                  bloc: SessionsBloc(),
                  builder: (context, state) {
                    if(SessionsBloc().activeSessions != null &&
                        SessionsBloc().activeSessions.isNotEmpty) {
                      List<DropdownMenuItem> items = [];

                      for(PojoSession s in SessionsBloc().activeSessions) {
                        //  if(selectedKretaAccount == null || s.username != selectedKretaAccount.username){
                        items.add(DropdownMenuItem(child: Text(s.username),
                          value: s,));
                        if(selectedKretaAccount?.username == s.username) {
                          selectedKretaAccount = s;
                        }
                        //  }
                      }
                      if(items.isEmpty) {
                        items.add(DropdownMenuItem(child: Text(
                            "add Kréta account"), value: "add Kréta account",));
                      }
                      items.forEach((item) =>
                          print("opo111: ${item.value?.username}"));
                      print("opo222: ${selectedKretaAccount?.username}");
                      print("opo333: ${items
                          .where((item) => item.value == selectedKretaAccount)
                          .length == 1}");

                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: DropdownButton(
                            value: selectedKretaAccount,
                            onChanged: (item) {
                              if(item == "add Kréta account") {
                                Navigator.of(context).pushNamed("/kreta/login");
                              }else {
                                SelectedSessionBloc().dispatch(
                                    SelectedSessionSetEvent(item));
                                setState(() {
                                  selectedKretaAccount = item;
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


              ],
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
                  Hero(
                    tag: "settings",
                    child: ListTile(
                        onTap: () {
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
                        leading: Transform.rotate(
                            angle: -math.pi,
                            child: Icon(FontAwesomeIcons.signOutAlt)
                        ),
                        title: Text(locText(
                            context, key: "textview_logout_drawer")),
                        onTap: () async {
                          await AppState.logout();
                        },
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 10),
                        child: Builder(
                            builder: (context) {
                              Icon icon = isDark ?
                              Icon(FontAwesomeIcons.solidSun,
                                  color: Colors.orangeAccent, size: 43) :
                              Icon(FontAwesomeIcons.solidMoon,
                                  color: Colors.black45, size: 39);

                              return IconButton(
                                iconSize: 50,
                                icon: icon,
                                onPressed: () async {
                                  if(await HazizzTheme.isDark()) {
                                    DynamicTheme.of(context).setThemeData(
                                        HazizzTheme.lightThemeData);
                                    await HazizzTheme.setLight();
                                    isDark = false;
                                  }else {
                                    DynamicTheme.of(context).setThemeData(
                                        HazizzTheme.darkThemeData);
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
    );
  }

}
