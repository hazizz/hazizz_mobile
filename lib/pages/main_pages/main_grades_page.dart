import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/listItems/grade_header_item_widget.dart';
import 'package:mobile/listItems/grade_item_widget.dart';


import 'package:sticky_headers/sticky_headers.dart';

import '../../hazizz_localizations.dart';

class GradesPage extends StatefulWidget {

  MainGradesBloc gradesBloc;

  GradesPage({Key key, this.gradesBloc}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "grades");
  }


  @override
  _GradesPage createState() => _GradesPage(gradesBloc);
}

class _GradesPage extends State<GradesPage> with SingleTickerProviderStateMixin {

  final MainGradesBloc gradesBloc;

  _GradesPage(this.gradesBloc){

  }


  //List<PojoTask> task_data = List();

  // lényegében egy onCreate
  @override
  void initState() {
    // getData();
  //  gradesBloc.dispatch(FetchData());
    //   gradesBloc.fetchMyTasks();
    if(gradesBloc.currentState is ResponseError) {
      gradesBloc.dispatch(FetchData());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new RefreshIndicator(
            child: BlocBuilder(
                bloc: gradesBloc,
                //  stream: gradesBloc.subject.stream,
                builder: (_, HState state) {
                  if (state is ResponseDataLoaded) {
                    print("sadsadsad?: ${state.data}");
                    PojoGrades p = state.data;
                    Map<String, List<PojoGrade>> grades = state.data.grades;
                    print("sadsadsad?: ${state.data.grades}");
                    int itemCount = grades.keys.length;

                    print("log: itme count: $itemCount");

                    return new ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (BuildContext context, int index) {

                        String key = grades.keys.elementAt(index);

                        dynamic item = 2;// itemList[index];
                        if(true){
                          return new StickyHeader(
                            header: GradeHeaderItemWidget(subjectName: key),
                            content: Builder(
                              builder: (context) {
                                List<GradeItemWidget> gradeSubjects = new List();
                                for(PojoGrade pojoGrade in grades[key]){
                                  gradeSubjects.add(GradeItemWidget(pojoGrade: pojoGrade));
                                }
                                return Column(
                                    children: gradeSubjects
                                );
                              }
                            ),
                          );

                        }
                      }
                    );
                  } else if (state is ResponseEmpty) {
                    return Center(child: Text("Empty"));
                  } else if (state is ResponseWaiting) {
                    //return Center(child: Text("Loading Data"));
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Center(
                      child: Text("Uchecked State: ${state.toString()}"));
                }

            ),
            onRefresh: () async =>
                gradesBloc.dispatch(FetchData()) //await getData()
        )
    );
  }
}


