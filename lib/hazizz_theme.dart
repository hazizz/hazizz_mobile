import 'package:flutter/material.dart';


class HazizzTheme{

  static final Color
  red = Color.fromRGBO(242, 59, 80, 1),
  yellow = Color.fromRGBO(255, 202, 4, 1),
  white = Color.fromRGBO(232, 240, 223, 1),
  lightblue = Color.fromRGBO(73, 216, 216, 1),
  blue = Color.fromRGBO(54, 177, 191, 1),



  headerColor = Colors.red,
  homeworkColor = Colors.green,
  testColor = Colors.red,
  oralTestColor = Colors.purple,
  assignmentColor = Colors.yellow,

  formColor = Colors.grey.withAlpha(120);


  static Color get warningColor => red;



  static final ThemeData lightThemeData = new ThemeData(
    accentColor: red,
    // primaryColorLight: lightblue,
    primaryColorDark: blue,
    primaryColor: lightblue,
    errorColor: red,
    textSelectionHandleColor: Colors.black,
 //   textTheme: Colors.black,
    /*
    appBarTheme: AppBarTheme(
      color: lightblue
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: red
    )
      */


  );
}