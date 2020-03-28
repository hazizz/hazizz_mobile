import 'package:flutter/widgets.dart';

abstract class TabWidget extends StatefulWidget {
  String tabName;

  TabWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return null;
  }

  String getUIName(BuildContext context);
}