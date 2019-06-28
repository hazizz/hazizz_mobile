import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/group_bloc.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/listItems/subject_item_widget.dart';

import '../../hazizz_localizations.dart';

import '../../hazizz_localizations.dart';


class GroupSubjectsPage extends StatefulWidget {
  // This widget is the root of your application.

  String getTabName(BuildContext context){
    return locText(context, key: "subjects");
  }

  final GroupSubjectsBloc groupSubjectsBloc;

  GroupSubjectsPage({Key key, @required this.groupSubjectsBloc}) : super(key: key);

  @override
  _GroupSubjectsPage createState() => _GroupSubjectsPage(groupSubjectsBloc);
}

class _GroupSubjectsPage extends State<GroupSubjectsPage> with AutomaticKeepAliveClientMixin {

  GroupSubjectsBloc groupSubjectsBloc;

  _GroupSubjectsPage(this.groupSubjectsBloc);

  @override
  void initState() {
    if(groupSubjectsBloc.currentState is ResponseError) {
      groupSubjectsBloc.dispatch(FetchData());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showAddSubjectDialog(context, groupId: 2);
          },
          child: Icon(Icons.add),
        ),
        body: new RefreshIndicator(
            child: BlocBuilder(
                bloc: groupSubjectsBloc,
                builder: (_, HState state) {
                  if (state is ResponseDataLoaded) {
                    List<PojoSubject> subjects = state.data;
                    return new ListView.builder(
                        itemCount: subjects.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SubjectItemWidget(subject: subjects[index]);

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
            onRefresh: () async => groupSubjectsBloc.dispatch(FetchData()) //await getData()
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


