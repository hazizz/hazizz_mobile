import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/main_tab_blocs/main_tab_blocs.dart';
import 'package:mobile/blocs/schedule_bloc.dart';
import 'package:mobile/communication/pojos/PojoClass.dart';
import 'package:mobile/listItems/class_item_widget.dart';

import '../../hazizz_localizations.dart';


class SchedulesTabPage extends StatefulWidget {

  List<PojoClass> classes;

  bool noClasses = false;

  SchedulesTabPage({Key key, @required this.classes}) : super(key: key){

  }

  SchedulesTabPage.noClasses({Key key,}) : super(key: key){
    noClasses = true;
  }

  @override
  _SchedulesTabPage createState() => _SchedulesTabPage();
}

class _SchedulesTabPage extends State<SchedulesTabPage> with TickerProviderStateMixin {
  _SchedulesPage(){}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.noClasses){
      return Stack(
        children: <Widget>[
          Center(child: Text(locText(context, key: "no_classes_today"))),
          Builder(
            builder: (context){
              if(MainTabBlocs().schedulesBloc.currentDayIndex >= 5) {
                return Positioned(
                    right: 0, bottom: 10,
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text(
                              locText(context, key: "next_week").toLowerCase()),
                          Icon(FontAwesomeIcons.chevronRight)
                        ],
                      ),
                      onPressed: () {
                        MainTabBlocs().schedulesBloc.dispatch(
                            ScheduleFetchEvent(
                                yearNumber: MainTabBlocs().schedulesBloc
                                    .currentYearNumber,
                                weekNumber: MainTabBlocs().schedulesBloc
                                    .currentWeekNumber + 1));
                      },
                    )
                );
              }
              return Container();
            },
          )
        ],
      );
    }

    return ListView.builder(
      itemCount: widget.classes.length,
      itemBuilder: (BuildContext context, int index) {
        return ClassItemWidget(pojoClass: widget.classes[index]);
      }
    );
  }
}


