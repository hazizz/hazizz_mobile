import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hazizz_mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGrade.dart';
import 'package:hazizz_mobile/communication/pojos/PojoGrades.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/listItems/TaskHeaderItemWidget.dart';
import 'package:hazizz_mobile/listItems/TaskItemWidget.dart';
import 'package:hazizz_mobile/listItems/grade_header_item_widget.dart';
import 'package:hazizz_mobile/listItems/grade_item_widget.dart';


import 'package:sticky_headers/sticky_headers.dart';

class GradesPage extends StatefulWidget {

  MainGradesBloc gradesBloc;

  GradesPage({Key key, this.gradesBloc}) : super(key: key);

  static final String tabName = "Grades";

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
    gradesBloc.dispatch(FetchData());
    //   gradesBloc.fetchMyTasks();
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
                    Map<String, List<PojoGrade>> grades = state.data.grades;

                    int itemCount = grades.keys.length;

                    List itemList = new List();


                    List<int> border = new List();

                    /*
                    int i = 0;
                    for(String gradeKey in grades.keys){
                   //   itemList.add(gradeKey);
                      border.add(i);
                      for(PojoGrade grade in grades[gradeKey]){
                        itemList.add(grade);
                        i++;
                      }
                      itemCount += grades[gradeKey].length;
                    }
                    */

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

                        }else if(item is PojoGrade){
                          if(border.contains(index)){
                            return new StickyHeader(
                              header: GradeHeaderItemWidget(subjectName: "hétfő"),
                              content: Column(
                                  children: [GradeItemWidget(pojoGrade: (itemList[index+1])),
                                    Text("ASD"), Text("ASD"), Text("ASD"), Text("ASD"),
                                  ]

                              ),
                            );
                          }
                          return new GradeItemWidget(pojoGrade: item);

                        }else{
                          return Text("ERROR");
                        }
                        /*
                        for(String gradeKey in grades.keys){
                          bool isFirst = true;
                          print("log: niga");
                          for(PojoGrade grade in grades[gradeKey]) {
                            if(isFirst) {
                              return new StickyHeader(
                                header: GradeHeaderItemWidget(
                                  subjectName: gradeKey),
                                  content: GradeItemWidget(pojoGrade: grade),
                              );
                            }else{
                              GradeItemWidget(pojoGrade: grade);
                            }
                            isFirst = false;
                          }
                        }
                        */
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


