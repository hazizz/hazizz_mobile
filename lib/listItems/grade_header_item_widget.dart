import 'package:flutter/material.dart';

class GradeHeaderItemWidget extends StatelessWidget{
  String subjectName;

  GradeHeaderItemWidget({this.subjectName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Card(
          color: Theme.of(context).primaryColorDark,
          child: InkWell(
              child: Row(
                children: <Widget>[
                  Text(subjectName),
                  SizedBox(width: 20),
                ],
              )
          )
      ),
    );
  }
}
