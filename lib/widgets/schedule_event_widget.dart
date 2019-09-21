import 'package:flutter/material.dart';

import '../hazizz_date.dart';
import '../hazizz_localizations.dart';
import '../hazizz_theme.dart';

class ScheduleEventWidget extends StatelessWidget{
  // String days;
  // String date;

  String text;

  ScheduleEventWidget.beforeClasses(BuildContext context){
    text = locText(context, key: "classes_not_started");
  }

  ScheduleEventWidget.afterClasses(BuildContext context){
    text = locText(context, key: "classes_over");
  }

  ScheduleEventWidget.breakTime(BuildContext context){
    text = locText(context, key: "classes_break");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
       // margin: EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 2),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: HazizzTheme.red,
        child: Padding(
          padding: const EdgeInsets.only(top: 1.5, bottom: 1.5, left: 8),
          child: Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),)
        )
    );
  }
}
