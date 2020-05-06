import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({ @required this.builder, this.duration = const Duration(milliseconds: 400), this.dismissible = true }) : super();

  final WidgetBuilder builder;
  final Duration duration;

  final bool dismissible;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => dismissible;

  @override
  Duration get transitionDuration => duration;

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;



  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut
      ),
      child: child
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => "Label";

}
