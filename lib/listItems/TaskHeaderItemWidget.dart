import 'package:flutter/material.dart';

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
          color: Colors.blue,
          child: InkWell(
              child: Row(
                children: <Widget>[
                  Text("holnap"),
                  SizedBox(width: 20),
                  Text("${dateTime.toString()}"),
                ],
              )
          )
      ),
    );
  }
}
