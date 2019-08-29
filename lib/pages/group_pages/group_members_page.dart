import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/listItems/member_item_widget.dart';
import 'package:mobile/managers/welcome_manager.dart';


import '../../hazizz_localizations.dart';


class GroupMembersPage extends StatefulWidget {
  // This widget is the root of your application.

  String getTabName(BuildContext context){
    return locText(context, key: "groupMembers").toUpperCase();
  }

  final GroupMembersBloc groupMembersBloc;

  GroupMembersPage({Key key, @required this.groupMembersBloc}) : super(key: key);

  @override
  _GroupMembersPage createState() => _GroupMembersPage(groupMembersBloc);
}

class _GroupMembersPage extends State<GroupMembersPage> with AutomaticKeepAliveClientMixin {

  GroupMembersBloc groupMembersBloc;

  _GroupMembersPage(this.groupMembersBloc);

  @override
  void initState() {
    if(groupMembersBloc.currentState is ResponseError) {
      groupMembersBloc.dispatch(FetchData());
    }

    /*
    WelcomeManager.getMembers().then((isNewComer){
      if(isNewComer){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FeatureDiscovery.discoverFeatures(
            context,
            ['featureId1'],
          );
        });
      }
    });
    */

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(FontAwesomeIcons.userPlus),
          heroTag: "hero_fab_members",
          onPressed: (){
            showInviteDialog(context, group: groupMembersBloc.group);
          },
        ),
        body: new RefreshIndicator(
            child: Stack(
              children: <Widget>[
                ListView(),
                BlocBuilder(
                    bloc: groupMembersBloc,
                    builder: (_, HState state) {
                      if (state is ResponseDataLoaded) {
                        List<PojoUser> members = state.data;
                        return new ListView.builder(
                            itemCount: members.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MemberItemWidget(member: members[index]);

                            }
                        );
                      } else if (state is ResponseEmpty) {
                        return Container();
                      } else if (state is ResponseWaiting) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      return Center(
                          child: Text(locText(context, key: "info_something_went_wrong")));
                    }
                ),
              ],
            ),
            onRefresh: () async => groupMembersBloc.dispatch(FetchData()) //await getData()
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


