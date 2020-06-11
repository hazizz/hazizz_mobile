import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/group/group_bloc.dart';
import 'package:mobile/blocs/other/request_event.dart';
import 'package:mobile/blocs/other/response_states.dart';
import 'package:mobile/communication/pojos/PojoSubject.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/widgets/listItems/subject_item_widget.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';
import 'package:mobile/custom/hazizz_localizations.dart';

class GroupSubjectsPage extends StatefulWidget {
  String getTabName(BuildContext context){
    return localize(context, key: "subjects").toUpperCase();
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(groupSubjectsBloc.state is ResponseError) {
        groupSubjectsBloc.add(FetchData());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "hero_fab_subjects",
          onPressed: () async {
            PojoSubject success = await showAddSubjectDialog(context, groupId: groupSubjectsBloc.groupId);
            if(success != null){
              groupSubjectsBloc.add(FetchData());
            }
          },
          child: Icon(FontAwesomeIcons.plus),
        ),
        body: new RefreshIndicator(
            child: Stack(
              children: <Widget>[
                ListView(),
                BlocBuilder(
                    bloc: groupSubjectsBloc,
                    builder: (_, HState state) {
                      if (state is ResponseDataLoaded) {
                        List<PojoSubject> subjects = state.data;
                        return new ListView.builder(
                         //   physics: BouncingScrollPhysics(),
                            itemCount: subjects.length,
                            itemBuilder: (BuildContext context, int index) {
                              if(index >= subjects.length-1){
                                return addScrollSpace(SubjectItemWidget(subject: subjects[index]));
                              }
                              return SubjectItemWidget(subject: subjects[index]);

                            }
                        );
                      } else if (state is ResponseEmpty) {
                        return Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Text(localize(context, key: "no_subjects_yet")),
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
              ],
            ),
            onRefresh: () async => groupSubjectsBloc.add(FetchData()) //await getData()
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}


