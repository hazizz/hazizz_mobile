import 'package:flutter/material.dart';

import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/widgets/card_header_widget.dart';
import 'package:mobile/extension_methods/datetime_extension.dart';

class TaskHeaderItemWidget extends StatelessWidget{
  final DateTime dateTime;

  TaskHeaderItemWidget({Key key, this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration d = dateTime.difference(DateTime.now().subtract(Duration(days: 1)));
    int days = d.inDays;

    Color backColor;

    String title;
    if(days == 0){
      backColor = HazizzTheme.yellow;
      title = localize(context, key: "today");
    }else if(days == 1){
      title = localize(context, key: "tomorrow");
    }else if(days < 0){
      title = localize(context, key: "days_ago", args: [days.abs().toString()]);
      backColor = HazizzTheme.red;
    }

    else{
      title = localize(context, key: "days_later", args: [days.toString()]);
    }
    return CardHeaderWidget(
      text: dateTime.daysDifference(context),
      secondText: dateTime.hazizzShowDateFormat,
      backgroundColor: backColor,
    );
  }
}
