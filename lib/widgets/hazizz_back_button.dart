import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HazizzBackButton extends StatelessWidget{
  final Function onPressed;

  final Color color;
  HazizzBackButton({this.onPressed}) : color = null;

  HazizzBackButton.light() : onPressed = null, color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.arrowLeft, color: color,),
      onPressed: onPressed ?? (){
        Navigator.maybePop(context);
        return true;
      }
    );
  }
}