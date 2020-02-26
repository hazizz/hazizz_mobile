import 'package:flutter/material.dart';

Widget addScrollSpace(Widget child, {double space = 85}){
  return Padding(
    padding: EdgeInsets.only(bottom: space),
    child: child,
  );
}