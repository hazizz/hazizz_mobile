import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/listItems/grade_header_item_widget.dart';
import 'package:mobile/listItems/grade_item_widget.dart';
import 'package:sticky_header_list/sticky_header_list.dart';

import '../../hazizz_localizations.dart';

class GradesPage extends StatefulWidget  {

  GradesPage({Key key}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "grades").toUpperCase();
  }
  
  @override
  _GradesPage createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> with SingleTickerProviderStateMixin , AutomaticKeepAliveClientMixin {


  _GradesPage(){

  }


  //List<PojoTask> task_data = List();

  // lényegében egy onCreate
  @override
  void initState() {
    // getData();
  //  gradesBloc.dispatch(FetchData());
    //   gradesBloc.fetchMyTasks();
    print("created Grades PAge");
    /*
    if(gradesBloc.currentState is ResponseError) {
      gradesBloc.dispatch(FetchData());
    }
    */
    super.initState();
  }

  @override
  void dispose() {
   // gradesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new RefreshIndicator(
        child: Stack(
          children: <Widget>[
            ListView(),
            BlocBuilder(
                bloc: MainTabBlocs().gradesBloc,
                //  stream: gradesBloc.subject.stream,
                builder: (_, HState state) {
                  if (state is ResponseDataLoaded) {
                    print("sadsadsad?: ${state.data}");
                    Map<String, List<PojoGrade>> grades = state.data.grades;
                    print("sadsadsad?: ${state.data.grades}");
                    int itemCount = grades.keys.length;

                    /*
                for(List<PojoGrade> listOfGrades in grades){

                }
                */

                    /*
                grades.forEach((String key, List<PojoGrade> value){
                  itemCount += value.length;
                });
                */

                    print("log: itme count: $itemCount");

                    /*
                return new ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {

                    String key = grades.keys.elementAt(index);

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
                );
                */

                    return new StickyList.builder(
                        itemCount: itemCount,
                        builder: (BuildContext context, int index) {

                          String key = grades.keys.elementAt(index);

                          List<Widget> widgetList = List();
                          widgetList.add(GradeHeaderItemWidget(subjectName: key,));
                          for(PojoGrade grade2 in grades[key]){
                            widgetList.add(GradeItemWidget(pojoGrade: grade2,));
                          }

                          return new HeaderRow(
                              child: Column(
                                  children: widgetList
                              ));
                          /*
                      if (index == 0 || tasks[index].dueDate
                          .difference(tasks[index - 1].dueDate)
                          .inDays > 0) {
                        return new HeaderRow(
                            child: Column(
                                children: [
                                  TaskHeaderItemWidget(dateTime: tasks[index].dueDate),
                                  TaskItemWidget(pojoTask: tasks[index])
                                ]
                            ));
                      } else {
                        return RegularRow(child: TaskItemWidget(pojoTask: tasks[index]),
                        );
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

          ],
        ),
        onRefresh: () async{
          MainTabBlocs().gradesBloc.dispatch(FetchData()); //await getData()
          print("log: refreshing grades");
          return;
        }
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


