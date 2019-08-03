import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoUser.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/listItems/member_item_widget.dart';


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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){showInviteDialog(context, group: groupMembersBloc.group);}, child: Icon(Icons.person_add),),
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
                        return Center(child: Text("Empty"));
                      } else if (state is ResponseWaiting) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      return Center(
                          child: Text("Uchecked State: ${state.toString()}"));
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


