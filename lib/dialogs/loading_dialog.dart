import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {

  final Widget child;
  final bool show;
  final Color color;
  final Animation<Color> valueColor;

  LoadingDialog({
    Key key,
    @required this.child,
    @required this.show,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(child);
    if (show) {
      final modal = new Stack(
        children: [

          new Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
            child: new CircularProgressIndicator(
              valueColor: valueColor,
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height,
      child: Stack(
        children: widgetList,
      ),
    );
  }
}