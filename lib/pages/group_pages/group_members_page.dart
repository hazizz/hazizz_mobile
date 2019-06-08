import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:hazizz_mobile/blocs/group_bloc.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/communication/pojos/PojoUser.dart';
import 'package:hazizz_mobile/listItems/member_item_widget.dart';
=======
import 'package:flutter_hazizz/blocs/group_bloc.dart';
import 'package:flutter_hazizz/blocs/request_event.dart';
import 'package:flutter_hazizz/blocs/response_states.dart';
import 'package:flutter_hazizz/communication/pojos/PojoUser.dart';
import 'package:flutter_hazizz/listItems/member_item_widget.dart';
>>>>>>> 697a6e3b071e12017449a7ca76eb8a9feb3f5ba0

class GroupMembersPage extends StatefulWidget {
  // This widget is the root of your application.

  static final String tabName = "Members";

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
    groupMembersBloc.dispatch(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: null, child: Icon(Icons.add),),
        body: new RefreshIndicator(
            child: BlocBuilder(
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
            onRefresh: () async => groupMembersBloc.dispatch(FetchData()) //await getData()
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


