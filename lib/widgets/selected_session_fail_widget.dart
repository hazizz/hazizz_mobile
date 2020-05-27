import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile/custom/hazizz_localizations.dart';

class SelectedSessionFailWidget extends StatefulWidget {
  SelectedSessionFailWidget({Key key}) : super(key: key);

  @override
  _SelectedSessionFailWidgetState createState() =>
      _SelectedSessionFailWidgetState();
}

class _SelectedSessionFailWidgetState extends State<SelectedSessionFailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 1),
        child: Row(
          children: <Widget>[
            Spacer(),
            AutoSizeText(
              localize(context, key: "failed_session"),
              style: TextStyle(fontSize: 14),
              maxFontSize: 14,
              minFontSize: 11,
              maxLines: 1,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}