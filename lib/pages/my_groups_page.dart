import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hazizz_mobile/blocs/group_bloc.dart';
import 'package:hazizz_mobile/blocs/my_groups_bloc.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGroup.dart';
import 'package:hazizz_mobile/communication/pojos/PojoUser.dart';
import 'package:hazizz_mobile/listItems/group_item_widget.dart';
import 'package:hazizz_mobile/listItems/member_item_widget.dart';


class MyGroupsPage extends StatefulWidget {
  // This widget is the root of your application.

   final String title = "My groups";

  MyGroupsBloc myGroupsBloc = new MyGroupsBloc();

  MyGroupsPage({Key key}) : super(key: key);

  @override
  _MyGroupsPage createState() => _MyGroupsPage();
}

class _MyGroupsPage extends State<MyGroupsPage> with AutomaticKeepAliveClientMixin {


  _MyGroupsPage();

  @override
  void initState() {
    widget.myGroupsBloc.dispatch(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new RefreshIndicator(
            child: BlocBuilder(
                bloc: widget.myGroupsBloc,
                builder: (_, HState state) {
                  if (state is ResponseDataLoaded) {
                    List<PojoGroup> groups = state.data;
                    return new ListView.builder(
                        itemCount: groups.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GroupItemWidget(group: groups[index]);
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
            onRefresh: () async => widget.myGroupsBloc.dispatch(FetchData()) //await getData()
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


