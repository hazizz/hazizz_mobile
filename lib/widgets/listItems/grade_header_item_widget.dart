import 'package:flutter/material.dart';
import 'package:mobile/widgets/card_header_widget.dart';
import "package:mobile/extension_methods/string_first_upper_extension.dart";
import "package:mobile/extension_methods/datetime_extension.dart";

class GradeHeaderItemWidget extends StatelessWidget{
  final String subjectName;
  final String gradesAverage;
  final DateTime date;

  GradeHeaderItemWidget.bySubject({this.subjectName, this.gradesAverage}) : date = null;

  GradeHeaderItemWidget.byDate({this.date}) : subjectName = null, gradesAverage = null ;

  @override
  Widget build(BuildContext context) {
    if(date == null){
      return CardHeaderWidget(
        text: subjectName.toUpperFirst(),
        secondText: gradesAverage,
      );
    }
    return CardHeaderWidget(
      text: date.hazizzShowDateFormat,
    );
  }
}
