import 'package:flutter/material.dart';

import 'package:mobile/custom/hazizz_date.dart';
import 'package:mobile/widgets/card_header_widget.dart';
import "package:mobile/extension_methods/extension_first_upper.dart";

class GradeHeaderItemWidget extends StatelessWidget{
  String subjectName;

  String gradesAvarage;

  DateTime date;

  GradeHeaderItemWidget.bySubject({this.subjectName, this.gradesAvarage});

  GradeHeaderItemWidget.byDate({this.date});

  @override
  Widget build(BuildContext context) {
    if(date == null){
      return CardHeaderWidget(
        text: subjectName.toUpperFirst(),
        secondText: gradesAvarage,
      );
    }
    return CardHeaderWidget(
      text: hazizzShowDateFormat(date),
    );
  }
}
