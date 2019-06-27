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
    return SizedBox(
      height: 40.0,
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Theme.of(context).primaryColorDark,
          child: InkWell(
              child: Row(
                children: <Widget>[
                  Text("holnap"),
                  SizedBox(width: 20),
                  Text("${hazizzShowDateFormat(dateTime)}"),
                ],
              )
          )
      ),
    );
  }
}
