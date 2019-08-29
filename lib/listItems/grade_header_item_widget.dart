import 'package:flutter/material.dart';

class GradeHeaderItemWidget extends StatelessWidget{
  final String subjectName;

  final String gradesAvarage;

  GradeHeaderItemWidget({this.subjectName, this.gradesAvarage});

  @override
  Widget build(BuildContext context) {



    return Card(
        margin: EdgeInsets.only(left: 4, right: 4, bottom: 3, top: 3),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).primaryColorDark,
        child: InkWell(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 2, bottom: 2),
                  child: Text(subjectName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 2, bottom: 2),
                  child: Text(gradesAvarage, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
                ),
              ],
            )
        )
    );
  }
}
