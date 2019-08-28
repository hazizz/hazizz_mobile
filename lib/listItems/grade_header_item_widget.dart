import 'package:flutter/material.dart';

class GradeHeaderItemWidget extends StatelessWidget{
  final String subjectName;

  final String gradesAvarage;

  GradeHeaderItemWidget({this.subjectName, this.gradesAvarage});

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
                  child: Text(subjectName, style: TextStyle(fontSize: 20),),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all( 5.0),
                  child: Text(gradesAvarage, style: TextStyle(fontSize: 20))
                ),
              ],
            )
        )
    );
  }
}
