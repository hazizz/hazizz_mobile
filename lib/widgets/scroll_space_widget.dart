import 'package:flutter/material.dart';

Widget addScrollSpace(Widget child){
  return Padding(
    padding: const EdgeInsets.only(bottom: 85),
    child: child,
  );
}