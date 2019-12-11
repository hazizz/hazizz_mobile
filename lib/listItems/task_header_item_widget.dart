import 'package:flutter/material.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';

class TaskHeaderItemWidget extends StatelessWidget{
 // String days;
 // String date;
  DateTime dateTime;

  TaskHeaderItemWidget({Key key, this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final diffTask = dateTime.difference(new DateTime(dateTime.year, 1, 1, 0, 0));
    final int daysTask = diffTask.inDays;

    final diffNow = DateTime.now().difference(new DateTime(dateTime.year, 1, 1, 0, 0));
    final int daysNow = diffNow.inDays;


    /*


    int daysMonth = dateTime.month;
    int days = dateTime.difference(DateTime.now()).inDays;

    dateTime.difference(DateTime.now()).inMicroseconds

    dateTime.microsecondsSinceEpoch;
    */

    int days = daysTask - daysNow;

    Color backColor = Theme.of(context).primaryColorDark;

    String title;
    if(days == 0){
      backColor = HazizzTheme.yellow;
      title = locText(context, key: "today");
    }
    else if(days == 1){
      title = locText(context, key: "tomorrow");
    }else if(days < 0){
      title = locText(context, key: "days_ago", args: [days.abs().toString()]);
      backColor = HazizzTheme.red;
    }

    else{
      title = locText(context, key: "days_later", args: [days.toString()]);
    }
    return Card(
      margin: EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 2),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: backColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 1.5, bottom: 1.5, left: 4),
          child: InkWell(
              child: Row(
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                  SizedBox(width: 20),
                  Text("${hazizzShowDateFormat(dateTime)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              )
          ),
        )
    );
  }
}
