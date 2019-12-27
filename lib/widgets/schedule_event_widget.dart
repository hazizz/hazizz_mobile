import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/custom/hazizz_time_of_day.dart';
import 'package:mobile/theme/hazizz_theme.dart';

class ScheduleEventWidget extends StatelessWidget{

  String text;

  Duration timerClassStart;

  ScheduleEventWidget.beforeClasses(BuildContext context, HazizzTimeOfDay timeOfClassStart){
    timerClassStart = HazizzTimeOfDay.now().compare(timeOfClassStart);
    text = locText(context, key: "classes_not_started", args: [timerClassStart.inMinutes.toString()]);
  }

  ScheduleEventWidget.afterClasses(BuildContext context){
    text = locText(context, key: "classes_over");
  }

  ScheduleEventWidget.breakTime(BuildContext context, HazizzTimeOfDay timeOfClassStart){
    timerClassStart = HazizzTimeOfDay.now().compare( timeOfClassStart);
    text = locText(context, key: "classes_break", args: [timerClassStart.inMinutes.toString()]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: HazizzTheme.red,
      child: Padding(
        padding: const EdgeInsets.only(top: 1.8, bottom: 1.8, left: 6),
        child: Row(
          children: <Widget>[
            AutoSizeText(text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              maxLines: 1,
              maxFontSize: 20,
              minFontSize: 16,
            ),
          ],
        ),
      )
    );
  }
}
