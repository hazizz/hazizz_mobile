import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:logger_flutter/logger_flutter.dart';
import 'package:mobile/blocs/my_groups_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/hazizz_localizations.dart';
import 'package:mobile/listItems/group_item_widget.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';


class MyGroupsPage extends StatefulWidget {

   final String title = "My groups";

   String getTitle(BuildContext context){
     return locText(context, key: "my_groups");
   }

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
    return Container(//LogConsoleOnShake(
     // tag: "group",
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
              heroTag: "hero_fab_my_groups",

              child: Icon(FontAwesomeIcons.userPlus),
            onPressed: () async {
              await showJoinGroupDialog(context);
            }
          ),
          appBar: AppBar(
            leading: HazizzBackButton(),
            actions: <Widget>[
              IconButton(icon: Icon(FontAwesomeIcons.plus),
                onPressed: () async {
                  bool result = await showCreateGroupDialog(context);
                  if(result != null && result == true){
                    widget.myGroupsBloc.dispatch(FetchData());
                  }
                })
            ],
            title: Text(widget.getTitle(context)),
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
                      return Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Text(locText(context, key: "no_my_groups_yet")),
                              ),
                            )
                          ]
                      );
                    } else if (state is ResponseWaiting) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return Center(
                        child: Text("Uchecked State: ${state.toString()}"));
                  }
              ),
              onRefresh: () async => widget.myGroupsBloc.dispatch(FetchData()) //await getData()
          )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


