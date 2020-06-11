import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group/my_groups_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/listItems/group_item_widget.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';

class MyGroupsPage extends StatefulWidget {

   static const String title = "My groups";

   String getTitle(BuildContext context){
     return localize(context, key: "my_groups");
   }

  MyGroupsPage({Key key}) : super(key: key);

  @override
  _MyGroupsPage createState() => _MyGroupsPage();
}

class _MyGroupsPage extends State<MyGroupsPage> {

  MyGroupsBloc myGroupsBloc = new MyGroupsBloc();


  _MyGroupsPage();

  @override
  void initState() {
    myGroupsBloc.add(FetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: HazizzBackButton(),
          title: Text(widget.getTitle(context)),
        ),
        body: new RefreshIndicator(
            child: BlocBuilder(
                bloc: myGroupsBloc,
                builder: (_, HState state) {
                  if (state is ResponseDataLoaded) {
                    List<PojoGroup> groups = state.data;
                    return new ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(index == groups.length-1){
                          return addScrollSpace(GroupItemWidget(group: groups[index]));
                        }
                        return GroupItemWidget(group: groups[index]);
                      }
                    );
                  } else if (state is ResponseEmpty) {
                    return Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(localize(context, key: "no_my_groups_yet")),
                          ),
                        )
                      ]
                    );
                  } else if (state is ResponseWaiting) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Center(
                      child: Text(localize(context, key: "info_something_went_wrong")));
                }
            ),
            onRefresh: () async => myGroupsBloc.add(FetchData()) //await getData()
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "my_groups_page",
          child: Icon(FontAwesomeIcons.plus),
          onPressed: () async {
            bool result = await showCreateGroupDialog(context);
            if(result != null && result == true){
              myGroupsBloc.add(FetchData());
            }
          }
        ),
      ),
    );
  }
}


