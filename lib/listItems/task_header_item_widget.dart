import 'package:flutter/material.dart';

import '../hazizz_date.dart';
import '../hazizz_localizations.dart';

class TaskHeaderItemWidget extends StatelessWidget{
 // String days;
 // String date;
  DateTime dateTime;

  TaskHeaderItemWidget({this.dateTime});

  @override
  Widget build(BuildContext context) {
    int days = dateTime.difference(DateTime.now()).inDays;
    String title;
    if(days == 0){
      title = locText(context, key: "today");
    }
    else if(days == 1){
      title = locText(context, key: "tomorrow");
    }else{
      title = locText(context, key: "days_later", args: [days.toString()]);
    }
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.only(top: 1.5, bottom: 1.5, left: 4),
          child: InkWell(
              child: Row(
                children: <Widget>[
                  Text(title, style: TextStyle(fontSize: 24),),
                  SizedBox(width: 20),
                  Text("${hazizzShowDateFormat(dateTime)}", style: TextStyle(fontSize: 26)),
                ],
              )
          ),
        )
    );
  }
}
