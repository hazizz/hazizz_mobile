import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/grades_bloc.dart';
import 'package:mobile/blocs/main_tab/main_tab_blocs.dart';
import 'package:mobile/communication/custom_response_errors.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/enums/grade_type_enum.dart';
import 'package:mobile/enums/grades_sort_enum.dart';
import 'package:mobile/managers/preference_services.dart';
import 'package:mobile/services/selected_session_helper.dart';
import 'package:mobile/widgets/ad_widget.dart';
import 'package:mobile/widgets/flushbars.dart';
import 'package:mobile/widgets/listItems/grade_header_item_widget.dart';
import 'package:mobile/widgets/listItems/grade_item_widget.dart';
import 'package:mobile/widgets/selected_session_fail_widget.dart';
import 'package:mobile/widgets/tab_widget.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/pages/kreta_pages/kreta_service_holder.dart';

class GradesPage extends TabWidget  {

  GradesPage({Key key}) : super(key: key){
    tabName = "GradesTab";
    PreferenceService.getGradeRectForm().then((bool r){
      rectForm = r;
    });
  }

  getUIName(BuildContext context){
    return locText(context, key: "grades").toUpperCase();
  }

  @override
  _GradesPage createState() => _GradesPage();

  bool rectForm = false;
}

class _GradesPage extends State<GradesPage> with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {

  StreamController<LineTouchResponse> controller;

  final List<Widget> _tabList = [];

  TabController _tabController;

//  Map<String, List<PojoGrade>> grades;

  int currentPage = 0;

  @override
  void initState() {
    _tabController  = TabController(vsync: this, length: _tabList.length, initialIndex: currentPage);
    super.initState();
  }

  @override
  void dispose() {
    // gradesBloc.dispose();
    super.dispose();
  }

  Map<String, List<PojoGrade>> copyMap( Map<String, List<PojoGrade>> map){
    Map<String, List<PojoGrade>> m = {};
    map.forEach((s, l){
      m[s] = List.from(l);
    });
    return m;
  }

  Widget onLoaded(Map<String, List<PojoGrade>> g){
    print('kék100');

    g.forEach((s, l){
      l.forEach((g){
        print("kék: ${g.grade}");
      });
    });

    print('kék111');

    if(currentPage == 1){
      Map<String, List<PojoGrade>> grades = copyMap(MainTabBlocs().gradesBloc.grades.grades);

      for(String key in grades.keys){
        grades[key].removeWhere(
                (item) => item.gradeType != GradeTypeEnum.HALFYEAR
        );
      }
      int itemCount = grades.keys.length+1;
      print('kék144');

      if(grades.isNotEmpty){
        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            if(index == 0){
              return Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().tasksBloc.lastUpdated)));
            }
            if(grades.values.toList()[index-1].isNotEmpty){
              return GradeItemWidget.bySubject(
                pojoGrade: grades.values.toList()[index-1][0],
                alt_subject: grades.keys.toList()[index-1],
                rectForm: false
              );
            }
            return Container();
          }
        );
      }
      return Text("empty");

    }else if(currentPage == 2){
      Map<String, List<PojoGrade>> grades = copyMap(MainTabBlocs().gradesBloc.grades.grades);
      for(String key in grades.keys){
        grades[key].removeWhere(
          (item) => item.gradeType != GradeTypeEnum.ENDYEAR
        );
      }

      int itemCount = grades.keys.length+1;
      print('kék144');

      if(grades.isNotEmpty){
        return ListView.builder(
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              if(index == 0){
                return Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().tasksBloc.lastUpdated)));
              }
              if(grades.values.toList()[index-1].isNotEmpty){
                return GradeItemWidget.bySubject(
                  pojoGrade: grades.values.toList()[index-1][0],
                  alt_subject: grades.keys.toList()[index-1],
                  rectForm: false
                );
              }
              return Container();
            }
        );
      }
      return Text("empty");

    }

    print('kék155');


    if(MainTabBlocs().gradesBloc.currentGradeSort == GradesSort.BYSUBJECT){
      Map<String, List<PojoGrade>> grades = MainTabBlocs().gradesBloc.getGradesFromSession().grades;// pojoGrades.grades;

      if(currentPage == 0){
        for(String key in grades.keys){
          grades[key].removeWhere(
            (item) =>
              item.gradeType == GradeTypeEnum.HALFYEAR ||
              item.gradeType == GradeTypeEnum.ENDYEAR
          );
        }
        print('kék122');
      }

      int itemCount = grades.keys.length+1;

      if(grades.isEmpty){
        return Stack(
          children: <Widget>[
            Align(alignment: Alignment.topCenter, child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().gradesBloc.lastUpdated))),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: AutoSizeText(
                  locText(context, key: "no_grades_yet"),
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                  maxFontSize: 17,
                  minFontSize: 14,
                ),
              ),
            )
          ],
        );
      }
      return new ListView.separated(
          itemCount: itemCount,
          separatorBuilder: (context, index) {
            return Container();
            return showAd(context, show:  (itemCount<3 && index == itemCount-1) || (index!=0 && index%3==0), showHeader: true);
          },
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
                ],
              ),
              content: Builder(
                  builder: (context) {
                    List<Widget> widgetList = List();

                    if(widget.rectForm){
                      for(int i = grades[key].length-1; i >= 0; i--){
                        widgetList.add(GradeItemWidget.bySubject(pojoGrade: grades[key][i], rectForm: true,));
                      }
                      return Column(
                        children: <Widget>[
                          Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 0,
                              spacing: 0,
                              //runAlignment: WrapAlignment.end,
                              children: widgetList
                          ),
                          showAd(context, show: (itemCount<4 && index == itemCount-1) || (index!=0 && index%4==0))
                        ],
                      );
                    }

                    for(int i = grades[key].length-1; i >= 0; i--){
                      widgetList.add(GradeItemWidget.bySubject(pojoGrade: grades[key][i],));
                    }
                    widgetList.add(showAd(context, show: (itemCount<3 && index == itemCount-1) || (index!=0 && index%3==0), showHeader: true));
                    return Column(
                        children: widgetList
                    );
                  }
              ),
            );
          }
      );
    }

    else{// if(MainTabBlocs().gradesBloc.currentGradeSort == GradesSort.BYDATE){
      List<PojoGrade> gradesByDate =  MainTabBlocs().gradesBloc.getGradesByDateFromSession();

      if(currentPage == 0){
        gradesByDate.removeWhere(
                (item) =>
            item.gradeType == GradeTypeEnum.HALFYEAR ||
            item.gradeType == GradeTypeEnum.ENDYEAR
        );
        print('kék122');
      }

      gradesByDate = gradesByDate.reversed.toList();

      print("Grades page length: ${gradesByDate.length}");

      print("Grades page map: ${gradesByDate}");

      if(widget.rectForm){
        List<Widget> widgetList = [];
        for(PojoGrade gs in gradesByDate){
          widgetList.add(GradeItemWidget.byDate(pojoGrade: gs, rectForm: true,));
        }

        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().tasksBloc.lastUpdated))),
              Wrap(
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 0,
                  runSpacing: 0,
                  children: widgetList
              ),
              showAd(context, show: widgetList.isNotEmpty)
            ],
          ),
        );
      }
      int itemCount = gradesByDate.length+1;
      return new ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            if(index == 0){
              return Center(child: Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().tasksBloc.lastUpdated)));
            }
            Widget gradeItemWidget = GradeItemWidget.byDate(pojoGrade: gradesByDate[index-1],);

            return Column(
              children: <Widget>[
                gradeItemWidget,
                showAd(context, show: (itemCount<15 && index == itemCount-1) || (index!=0 && index%15==0), showHeader: true)
              ],
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            BlocBuilder(
              bloc: MainTabBlocs().gradesBloc,
              builder: (context, state){
                if(state is GradesLoadedState){
                  if(doesContainSelectedSession(state.failedSessions)){
                    return SelectedSessionFailWidget();
                  }
                }
                else if(state is GradesLoadedCacheState){
                  if(doesContainSelectedSession(state.failedSessions)){
                    return SelectedSessionFailWidget();

                  }
                }

                if(state is GradesWaitingState || state is GradesLoadedCacheState){
                  return LinearProgressIndicator(
                    value: null,
                  );
                }
                return Container();
              },
            ),
            Expanded(
              child: KretaServiceHolder(
                child: new RefreshIndicator(
                    child: Stack(
                      children: <Widget>[
                        ListView(),
                        Column(children: <Widget>[
                          if (currentPage == 0) Card(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6.0),
                                      child: Text("${locText(context, key: "sort_by")}:",
                                        style: TextStyle(fontSize: 16, color: currentPage != 0 ? Colors.grey : null ),
                                      ),
                                    ),
                                    DropdownButton(
                                      value: MainTabBlocs().gradesBloc.currentGradeSort,
                                      onChanged: currentPage == 0 ? (value){
                                        setState(() {
                                          MainTabBlocs().gradesBloc.currentGradeSort = value;
                                        });
                                      } : null,
                                      items: [
                                        DropdownMenuItem(child: Text(locText(context, key: "creation_date")), value: GradesSort.BYCREATIONDATE),
                                        DropdownMenuItem(child: Text(locText(context, key: "date")), value: GradesSort.BYDATE),
                                        DropdownMenuItem(child: Text(locText(context, key: "kreta_subject")), value: GradesSort.BYSUBJECT),
                                      ],
                                    ),
                                    Spacer(),

                                    IconButton(
                                      icon: Icon(widget.rectForm ? FontAwesomeIcons.th : FontAwesomeIcons.listUl),
                                      onPressed: (){
                                        setState(() {
                                          widget.rectForm = !widget.rectForm;
                                        });
                                        PreferenceService.setGradeRectForm(widget.rectForm);
                                      },
                                    ),
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                            child: BlocBuilder(
                                bloc: MainTabBlocs().gradesBloc,
                                builder: (_, GradesState state) {
                                  print("mystate: ${state}");

                                  if (state is GradesLoadedState) {
                                    print("mystate2: ${state.data.grades.values.toList()[0]}");

                                    return onLoaded(state.data.grades);
                                  }else if (state is GradesLoadedCacheState) {
                                    return onLoaded(state.data.grades);
                                  }else if (state is GradesWaitingState) {
                                    //return Center(child: Text("Loading Data"));
                                    return Center(child: CircularProgressIndicator(),);
                                  }else if(state is GradesErrorState ){
                                    if(state.hazizzResponse.pojoError != null && state.hazizzResponse.pojoError.errorCode == 138){
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        showKretaUnavailableFlushBar(context);
                                      });
                                    }

                                    else if(state.hazizzResponse.dioError == noConnectionError){

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
                                      return onLoaded(MainTabBlocs().gradesBloc.grades.grades);
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
                      MainTabBlocs().gradesBloc.add(GradesFetchEvent()); //await getData()
                      return;
                    }
                ),
              ),
            ),
            BottomNavigationBar(
                currentIndex: currentPage,
                onTap: (int index){
                  setState(() {
                    currentPage = index;
                    HazizzLogger.printLog("yeahh: ${currentPage}");
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    title: Container(),
                    icon:  Text(locText(context, key: "gradeType_midYear"), style: TextStyle(fontSize: 19)),
                    activeIcon: Text(locText(context, key: "gradeType_midYear"),
                      maxLines: 1,
                      style: TextStyle(color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold, /*backgroundColor: currentDayColor*/),
                    ),
                  ),
                  BottomNavigationBarItem(
                    title: Container(),

                    icon:  Text(locText(context, key: "gradeType_halfYear"),style: TextStyle(fontSize: 19)),
                    activeIcon: Text(locText(context, key: "gradeType_halfYear"),
                      maxLines: 1,
                      style: TextStyle(color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold, /*backgroundColor: currentDayColor*/),
                    ),
                  ),
                  BottomNavigationBarItem(
                    title: Container(),

                    icon:  Text(locText(context, key: "gradeType_endYear"),style: TextStyle(fontSize: 19)),
                    activeIcon: Text(locText(context, key: "gradeType_endYear"),
                      maxLines: 1,
                      style: TextStyle(color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold, /*backgroundColor: currentDayColor*/),
                    ),
                  )
                ]
            )
          ],
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}