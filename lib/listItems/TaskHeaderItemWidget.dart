import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../hazizz_date.dart';

class TaskHeaderItemWidget extends StatelessWidget{
 // String days;
 // String date;
  DateTime dateTime;

  TaskHeaderItemWidget({this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
              child: Row(
                children: <Widget>[
                  Text("holnap", style: TextStyle(fontSize: 20),),
                  SizedBox(width: 20),
                  Text("${hazizzShowDateFormat(dateTime)}", style: TextStyle(fontSize: 20)),
                ],
              )
          ),
        )
    );
  }
}
