import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hazizz_mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/communication/pojos/PojoClass.dart';
import 'package:hazizz_mobile/communication/pojos/task/PojoTask.dart';
import 'package:hazizz_mobile/listItems/TaskHeaderItemWidget.dart';
import 'package:hazizz_mobile/listItems/TaskItemWidget.dart';


import 'package:sticky_headers/sticky_headers.dart';

class SchedulesPage extends StatefulWidget {

  MainSchedulesBloc schedulesBloc;

  SchedulesPage({Key key, this.schedulesBloc}) : super(key: key);

  static final String tabName = "Schedules";

  @override
  _SchedulesPage createState() => _SchedulesPage(schedulesBloc);
}

class _SchedulesPage extends State<SchedulesPage> with SingleTickerProviderStateMixin {

  final MainSchedulesBloc schedulesBloc;

  _SchedulesPage(this.schedulesBloc){

  }


  //List<PojoTask> task_data = List();

  // lényegében egy onCreate
  @override
  void initState() {
    // getData();
    schedulesBloc.dispatch(FetchData());
    //   schedulesBloc.fetchMyTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new RefreshIndicator(
            child: BlocBuilder(
                bloc: schedulesBloc,
                //  stream: schedulesBloc.subject.stream,
                builder: (_, HState state) {
                  if (state is ResponseDataLoaded) {
                    Map<String, List<PojoClass>> classes = state.data.classes;

                    int itemCount = classes.keys.length;

                    for(String day in classes.keys){
                      // create pages
                    }

                  /*  return new ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (BuildContext context, int index) {
                          for(String gradeKey in grades.keys){
                            bool isFirst = true;
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
                        }
                    ); */
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
                schedulesBloc.dispatch(FetchData()) //await getData()
        )
    );
  }
}


