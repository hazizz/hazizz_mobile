import 'package:flutter/widgets.dart';

abstract class TabWidget extends StatefulWidget {
  final String tabName;

  TabWidget({Key key, @required this.tabName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return null;
  }

  String getUIName(BuildContext context);
}