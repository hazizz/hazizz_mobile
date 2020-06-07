import 'package:flutter/material.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/widgets/card_header_widget.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';
import 'package:mobile/extension_methods/duration_extension.dart';

class TaskHeaderItemWidget extends StatelessWidget{
  final DateTime dateTime;

  TaskHeaderItemWidget({Key key, this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration d = dateTime.difference(DateTime.now().subtract(1.days));
    int days = d.inDays;

    Color backColor;

    if(days == 0){
      backColor = HazizzTheme.yellow;
    }else if(days == 1){
    }else if(days < 0){
      backColor = HazizzTheme.red;
    }
    return CardHeaderWidget(
      text: dateTime.daysDifference(context),
      secondText: dateTime.hazizzShowDateFormat,
      backgroundColor: backColor,
    );
  }
}
