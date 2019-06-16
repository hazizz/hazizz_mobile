import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          color: Theme.of(context).primaryColorDark,
          child: InkWell(
              child: Row(
                children: <Widget>[
                  Text("holnap"),
                  SizedBox(width: 20),
                  Text("${DateFormat("yyyy.MM.dd").format(dateTime)}"),
                ],
              )
          )
      ),
    );
  }
}
