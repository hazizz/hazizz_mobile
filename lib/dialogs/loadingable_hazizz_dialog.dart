import 'package:flutter/material.dart';

import 'hazizz_dialog.dart';

class LoadingableHazizzDialog extends StatefulWidget {

  static const double buttonBarHeight = 48.0;

  final Widget header, content;

  final Widget actionButtons;

  final double height, width;

  LoadingableHazizzDialog({this.header, this.content, this.actionButtons,@required this.height,@required this.width}){

  }

  @override
  _LoadingableHazizzDialog createState() => new _LoadingableHazizzDialog();
}

class _LoadingableHazizzDialog extends State<LoadingableHazizzDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return HazizzDialog();
  }
}