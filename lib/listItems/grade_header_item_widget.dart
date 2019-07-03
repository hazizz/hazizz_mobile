import 'package:flutter/material.dart';

class GradeHeaderItemWidget extends StatelessWidget{
  String subjectName;

  GradeHeaderItemWidget({this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).primaryColorDark,
        child: InkWell(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all( 5.0),
                  child: Text(subjectName, style: TextStyle(fontSize: 18),),
                ),
                SizedBox(width: 20),
              ],
            )
        )
    );
  }
}
