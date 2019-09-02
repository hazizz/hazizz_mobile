import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/request_event.dart';
import 'package:mobile/blocs/response_states.dart';
import 'package:mobile/communication/errors.dart';
import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/communication/pojos/PojoGrades.dart';
import 'package:mobile/custom/formats.dart';
import 'package:mobile/listItems/grade_header_item_widget.dart';
import 'package:mobile/listItems/grade_item_widget.dart';
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

    print("log: itme count: $itemCount");


    return new ListView.builder(
        itemCount: itemCount +1,
        itemBuilder: (BuildContext context, int index) {

          if(index == 0){
            return Text(dateTimeToLastUpdatedFormat(context, MainTabBlocs().gradesBloc.lastUpdated));

          }

          String key = grades.keys.elementAt(index-1);

          String gradesAvarage = MainTabBlocs().gradesBloc.calculateAvarage(grades[key]);



          return StickyHeader(
            header: GradeHeaderItemWidget(subjectName: key, gradesAvarage: gradesAvarage),
            content: Builder(
                builder: (context) {
                  List<Widget> widgetList = List();

                  for(int i = grades[key].length-1; i >= 0; i--){
                    widgetList.add(GradeItemWidget(pojoGrade: grades[key][i],));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KretaServiceHolder(
        child: new RefreshIndicator(
          child: Stack(
            children: <Widget>[
              ListView(),
              BlocBuilder(
                  bloc: MainTabBlocs().gradesBloc,
                  //  stream: gradesBloc.subject.stream,
                  builder: (_, HState state) {
                    if (state is ResponseDataLoaded) {
                      return onLoaded(state.data);


                    }else if (state is ResponseDataLoadedFromCache) {
                      return onLoaded(state.data);
                    }
                    else if (state is ResponseEmpty) {
                      return Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Text(locText(context, key: "no_grades_yet")),
                              ),
                            )
                          ]
                      );
                    } else if (state is ResponseWaiting) {
                      //return Center(child: Text("Loading Data"));
                      return Center(child: CircularProgressIndicator(),);
                    }else if(state is ResponseError ){
                      if(state.errorResponse.pojoError != null && state.errorResponse.pojoError.errorCode == 138){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Toast.show(locText(context, key: "kreta_server_unavailable"), context, duration: 4, gravity:  Toast.BOTTOM);
                        });
                      }

                      else if(state.errorResponse.dioError == noConnectionError){
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Toast.show(locText(context, key: "info_noInternetAccess"), context, duration: 4, gravity:  Toast.BOTTOM);
                        });
                      }else{
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Toast.show(locText(context, key: "info_something_went_wrong"), context, duration: 4, gravity:  Toast.BOTTOM);
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

            ],
          ),
          onRefresh: () async{
            MainTabBlocs().gradesBloc.dispatch(FetchData()); //await getData()
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


