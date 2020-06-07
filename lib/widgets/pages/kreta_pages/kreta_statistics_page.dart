import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/kreta/kreta_statistics_bloc.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGradeAvarage.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/dialogs/dialog_collection.dart';
import 'package:mobile/widgets/hazizz_back_button.dart';
import 'package:mobile/widgets/listItems/grade_item_widget.dart';
import 'package:mobile/widgets/scroll_space_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mobile/extension_methods/duration_extension.dart';
class KretaStatisticsPage extends StatefulWidget {
  @override
  _KretaStatisticsPage createState() => _KretaStatisticsPage();
}

class _KretaStatisticsPage extends State<KretaStatisticsPage> {

  final KretaGradeStatisticsBloc gradeAvaragesBloc = KretaGradeStatisticsBloc();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    gradeAvaragesBloc.add(KretaGradeStatisticsFetchEvent());
    super.initState();
  }

  String selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          leading: HazizzBackButton(),
          title: Text(localize(context, key: "kreta_grade_statistics")),
        ),
      body: RefreshIndicator(
        onRefresh: () async{
          gradeAvaragesBloc.add(KretaGradeStatisticsFetchEvent());
        },
        child: Stack(
          children: <Widget>[
            ListView(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    BlocBuilder(
                      bloc: gradeAvaragesBloc,//MainTabBlocs().gradesBloc,
                      builder: (context, state){
                        if(state is KretaGradeStatisticsGetState){
                          List<DropdownMenuItem> items = [];

                          for(String key in gradeAvaragesBloc.gradeStatistics.keys){
                            items.add(DropdownMenuItem(child: Text(key), value: key, ));
                          }
                          return Center(
                              child: DropdownButton(
                                  value: selectedSubject,
                                  onChanged: (item) {
                                    setState(() {
                                      selectedSubject = item;
                                    });
                                    gradeAvaragesBloc.add(KretaGradeStatisticsGetEvent(subject: selectedSubject));
                                  },
                                  items: items
                              )
                          );
                        }
                        /*
                        if(MainTabBlocs().gradesBloc.grades != null && MainTabBlocs().gradesBloc.grades.grades.isNotEmpty){

                          if(selectedSubject == null){
                            selectedSubject = MainTabBlocs().gradesBloc.grades.grades.keys.toList()[0];
                          }

                          List<DropdownMenuItem> items = [];

                          for(String key in MainTabBlocs().gradesBloc.getGradesFromSession().grades.keys){
                            items.add(DropdownMenuItem(child: Text(key), value: key, ));
                          }
                          return Center(
                            child: DropdownButton(
                              value: selectedSubject,
                              onChanged: (item) {
                                setState(() {
                                  selectedSubject = item;
                                });
                              },
                              items: items
                            )
                          );
                        }
                        */
                        return Container();
                      },
                    ),
                    BlocBuilder(
                      bloc: gradeAvaragesBloc,
                      builder: (context, state){
                       // if(state is KretaGradeStatisticsLoadedState && selectedSubject != null &&  gradeAvaragesBloc.gradeAvarages.isNotEmpty){
                        //  PojoGradeAverage avarage = gradeAvaragesBloc.gradeAvarages.firstWhere((element) => element.subject == selectedSubject, orElse: () => null);
                        if(state is KretaGradeStatisticsGetState){
                          PojoGradeAverage avarage = state.currentGradeStatistic.gradeAverage;
                          if(avarage != null){
                            return Padding(
                              padding: const EdgeInsets.only( bottom: 10, top: 6),
                              child: Container(
                                width: 200,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("${localize(context, key: "average")}:", style: TextStyle(fontSize: 18),),
                                        Text(avarage.grade.toString(), style: TextStyle(fontSize: 18),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("${localize(context, key: "class_average")}:", style: TextStyle(fontSize: 18),),
                                        Text(avarage.classGrade.toString(), style: TextStyle(fontSize: 18),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("${localize(context, key: "difference")}:", style: TextStyle(fontSize: 18),),
                                        avarage.difference >= 0 ?
                                        Text("+${avarage.difference.toString()}", style: TextStyle(color: Colors.green, fontSize: 18),) :
                                        Text(avarage.difference.toString(), style: TextStyle(color: Colors.red, fontSize: 18))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: BlocConsumer(
                    bloc: gradeAvaragesBloc,//MainTabBlocs().gradesBloc,
                    listener: (context, state ){
                       if(state is KretaGradeStatisticsGetState){
                         try{
                           scrollController?.animateTo(
                              0,
                              duration: 600.milliseconds,
                              curve: Curves.easeInOutCubic
                           );
                         }catch(e){}
                       }
                    },
                    builder: (context, state){
                      if(state is KretaGradeStatisticsGetState) {
                        Widget buildItem(){
                          List<PojoGrade> grades = state.currentGradeStatistic.gradeList;

                          if(grades == null || grades.isEmpty){
                            return Center(child: Text(localize(context, key: "no_grades_yet")));
                          }
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: grades.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: <Widget>[
                                  GradeItemWidget.bySubject(pojoGrade: grades[index]),
                                  if(grades[index].accountId == "ghost")
                                    Positioned(top: 0, right: 0,
                                      child: IconButton(
                                        icon: Icon(FontAwesomeIcons.times, color: Colors.red,),
                                        onPressed: () {
                                          gradeAvaragesBloc.add(KretaGradeRemoveEvent(index: index));
                                        },
                                      )
                                    )
                                ],
                              );
                            }
                          );
                        }
                        return buildItem();
                      }
                      /*
                      if(state is GradesLoadedState){
                        return buildItem();
                      }else if(state is GradesLoadedCacheState){
                        return buildItem();
                      }
                      */
                      /*
                      Widget buildItem(){
                        List<PojoGrade> grades = MainTabBlocs().gradesBloc.getGradesFromSession().grades[selectedSubject];

                        if(grades == null || grades.isEmpty){
                          return Center(child: Text(localize(context, key: "no_grades_yet")));
                        }
                        return new ListView.builder(
                          itemCount: grades.length,
                          itemBuilder: (BuildContext context, int index) {

                            return GradeItemWidget.bySubject(pojoGrade: grades[index],);
                          }
                        );
                      }
                      if(state is GradesLoadedState){
                        return buildItem();
                      }else if(state is GradesLoadedCacheState){
                        return buildItem();
                      }
                      */
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () async {
          PojoGrade newGrade = await showAddGradeDialog(context, subject: gradeAvaragesBloc.currentSubject);
          if(newGrade  != null){
            gradeAvaragesBloc.add(KretaGradeAddEvent(grade: newGrade));
          }
        },
      ),
    );
  }
}


