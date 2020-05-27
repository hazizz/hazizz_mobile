import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/extension_methods/time_of_day_extension.dart';

class ScheduleEventWidget extends StatelessWidget{

  final String unlocalizedText;
  final Duration timerClassStart;

  ScheduleEventWidget.beforeClasses(BuildContext context, TimeOfDay timeOfClassStart)
    : timerClassStart = TimeOfDay.now().compare(timeOfClassStart),
      unlocalizedText = "classes_not_started";

  ScheduleEventWidget.afterClasses(BuildContext context)
    : timerClassStart = null,
      unlocalizedText = "classes_over";


  ScheduleEventWidget.breakTime(BuildContext context, TimeOfDay timeOfClassStart)
    : timerClassStart = TimeOfDay.now().compare( timeOfClassStart),
    unlocalizedText = "classes_break";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: HazizzTheme.red,
      child: Padding(
        padding: const EdgeInsets.only(top: 1.8, bottom: 1.8, left: 6),
        child: Row(
          children: <Widget>[
            AutoSizeText(
              unlocalizedText != "classes_over"
                  ? unlocalizedText.localize(context,
                    args: [timerClassStart?.inMinutes?.toString()]
              ) : unlocalizedText.localize(context),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              maxLines: 1,
              maxFontSize: 20,
              minFontSize: 16,
            ),
          ],
        ),
      )
    );
  }
}
