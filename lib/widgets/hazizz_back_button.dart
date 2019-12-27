import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HazizzBackButton extends StatelessWidget{
  Function onPressed;

  Color c;
  HazizzBackButton({this.onPressed});

  HazizzBackButton.light(){
    c = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    onPressed ??= (){
      Navigator.maybePop(context);
    };
    return IconButton(
      icon: Icon(FontAwesomeIcons.arrowLeft, color: c,),
      onPressed: onPressed
    );
  }

}