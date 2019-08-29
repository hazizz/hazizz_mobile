import 'package:flutter/widgets.dart';

class NotebookBackgroundWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FittedBox(

      fit: BoxFit.fitWidth,
      child: Image.asset(
        'assets/images/notebook_background.png',
        width: 3530,
        height: 1442,

      ),
    );
  }

}