import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/grades_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errors.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/enums/grades_sort_enum.dart';
import 'package:mobile/listItems/grade_header_item_widget.dart';
import 'package:mobile/listItems/grade_item_widget.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/grade_chart.dart';
import 'package:sticky_header_list/sticky_header_list.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:toast/toast.dart';

import '../../hazizz_localizations.dart';
import '../kreta_service_holder.dart';

class GradesPage extends StatefulWidget  {

  GradesPage({Key key}) : super(key: key);

  getTabName(BuildContext context){
    return locText(context, key: "grades").toUpperCase();
  }
  
  @override
  _GradesPage createState() => _GradesPage();
}

class _GradesPage extends State<GradesPage> with SingleTickerProviderStateMixin , AutomaticKeepAliveClientMixin {

  StreamController<LineTouchResponse> controller;


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

  GradesSort currentGradeSort = GradesSort.BYSUBJECT;

  Widget onLoaded(PojoGrades pojoGrades){
    Map<String, List<PojoGrade>> grades = pojoGrades.grades;
    int itemCount = grades.keys.length;

    if(grades.isEmpty){
      return Stack(
        children: <Widget>[
          Align(alignment: Alignment.topCenter, child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().gradesBloc.lastUpdated))),
          Center(child: Text(locText(context, key: "no_grades_yet")))
        ],
      );
    }

    /*
                  grades.forEach((String key, List<PojoGrade> value){
                    itemCount += value.length;
                  });
                  */

    if(currentGradeSort == GradesSort.BYSUBJECT){
      return new ListView.builder(
          itemCount: itemCount +1,
          itemBuilder: (BuildContext context, int index) {

            if(index == 0){
              return Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().gradesBloc.lastUpdated)));

            }

            String key = grades.keys.elementAt(index-1);

            String gradesAvarage = MainTabBlocs().gradesBloc.calculateAvarage(grades[key]);



            return StickyHeader(
              header: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: <Widget>[
                  GradeHeaderItemWidget.bySubject(subjectName: key, gradesAvarage: gradesAvarage),
                  Container(
                    color: Theme.of(context).backgroundColor,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: GradesChart(subjectName: key, grades: grades[key] ),
                  ),

                ],
              ),
              content: Builder(
                  builder: (context) {
                    List<Widget> widgetList = List();

                    for(int i = grades[key].length-1; i >= 0; i--){
                      widgetList.add(GradeItemWidget.bySubject(pojoGrade: grades[key][i],));
                    }
                    return Column(
                        children: widgetList
                    );
                  }
              ),
            );
          }
      );
    }

    List<PojoGrade> gradesByDate =  MainTabBlocs().gradesBloc.getGradesByDate();

    Map<DateTime, List<PojoGrade>> map = Map();

    int i = 0;
    for(PojoGrade grade in gradesByDate){
      if (i == 0 || gradesByDate[i].creationDate
          .difference(gradesByDate[i - 1].creationDate)
          .inDays >= 1) {
        map[gradesByDate[i].creationDate] = List();
        map[gradesByDate[i].creationDate].add(grade);

      }else{
        map[gradesByDate[i].creationDate].add(grade);
      }

      i++;
    }

    return new ListView.builder(
        itemCount: map.keys.length+1,
        itemBuilder: (BuildContext context, int index) {


          if(index == 0){
            return Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().tasksBloc.lastUpdated)));
          }

          DateTime key = map.keys.elementAt(index-1);


          return StickyHeader(
            header: GradeHeaderItemWidget.byDate(date: key),
            content: Builder(
                builder: (context) {
                  List<Widget> widgetList = List();

                  for(PojoGrade gs in map[key]){
                    widgetList.add(GradeItemWidget.byDate(pojoGrade: gs,));
                  }
                  return Container(

                    child: Column(
                        children: widgetList
                    ),
                  );
                }
            ),
          );
        }
    );



  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: KretaServiceHolder(
        child: new RefreshIndicator(
          child: Stack(
            children: <Widget>[
              ListView(),

              Column(children: <Widget>[
                Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Text("${locText(context, key: "sort_by")}:", style: TextStyle(fontSize: 16),),
                          ),

                          DropdownButton(
                            value: currentGradeSort,
                            onChanged: (value){
                              setState(() {
                                currentGradeSort = value;
                              });
                            },
                            items: [
                              DropdownMenuItem(child: Text(locText(context, key: "date")), value: GradesSort.BYDATE, ),
                              DropdownMenuItem(child: Text(locText(context, key: "subject")), value: GradesSort.BYSUBJECT, ),
                            ],
                          ),
                          // Text("Feladatok:"),

                          Spacer(),

                          /*
                          FlatButton(child: Text(locText(context, key: "apply").toUpperCase(), style: TextStyle(fontSize: 13),),
                            onPressed: (){

                              applyFilters();

                              MainTabBlocs().tasksBloc.dispatch(TasksFetchEvent());
                            },
                          )
                          */
                        ],
                      ),
                    )
                ),

                Expanded(
                  child: BlocBuilder(
                      bloc: MainTabBlocs().gradesBloc,
                      //  stream: gradesBloc.subject.stream,
                      builder: (_, GradesState state) {
                        if (state is GradesLoadedState) {
                          return onLoaded(state.data);


                        }else if (state is GradesLoadedCacheState) {
                          return onLoaded(state.data);
                        } else if (state is GradesWaitingState) {
                          //return Center(child: Text("Loading Data"));
                          return Center(child: CircularProgressIndicator(),);
                        }else if(state is GradesErrorState ){
                          if(state.hazizzResponse.pojoError != null && state.hazizzResponse.pojoError.errorCode == 138){
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showKretaUnavailableFlushBar(context, scaffoldState: scaffoldState);
                            });
                          }

                          else if(state.hazizzResponse.dioError == noConnectionError){
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showNoConnectionFlushBar(context, scaffoldState: scaffoldState);
                            });
                          }else{
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Flushbar(
                                icon: Icon(FontAwesomeIcons.exclamation, color: Colors.red,),

                                message: "${locText(context, key: "grades")}: ${locText(context, key: "info_something_went_wrong")}",
                                duration: Duration(seconds: 3),
                              );
                            });
                          }

                          if(MainTabBlocs().gradesBloc.grades != null){
                            return onLoaded(MainTabBlocs().gradesBloc.grades);
                          }
                          return Center(
                              child: Text(locText(context, key: "info_something_went_wrong")));
                        }
                        return Center(
                            child: Text(locText(context, key: "info_something_went_wrong")));
                      }

                  ),
                ),
              ],)

            ],
          ),
          onRefresh: () async{
            MainTabBlocs().gradesBloc.dispatch(GradesFetchEvent()); //await getData()
            print("log: refreshing grades");
            return;
          }
        ),
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


