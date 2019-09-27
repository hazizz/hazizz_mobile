import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



ThemeData theme(BuildContext context){

  return Theme.of(context);
}

class HazizzTheme{

  static const Color
  red = Color.fromRGBO(242, 59, 80, 1),
  yellow = Color.fromRGBO(255, 202, 4, 1),
  white = Color.fromRGBO(232, 240, 223, 1),
  lightblue = Color.fromRGBO(73, 216, 216, 1),
  blue = Color.fromRGBO(54, 177, 191, 1),
  purple = Color.fromRGBO(126, 1, 255, 1),




  grade5Color = Colors.green,
  grade4Color = Colors.lightGreenAccent,
  grade3Color = Colors.yellowAccent,
  grade2Color = Colors.orange,
  grade1Color = Colors.red,
  gradeNeutralColor = Colors.grey,


  headerColor = Colors.red,
  homeworkColor = Colors.green,
  testColor = red,
  oralTestColor = purple,
  assignmentColor = yellow
  ;

  static final Color formColor = Colors.grey.withAlpha(120);


  static Color get warningColor => red;



  static final ThemeData lightThemeData = new ThemeData(

    /*
    hoverColor: lightblue,
    indicatorColor: lightblue,
  //  pageTransitionsTheme: lightblue,
    primarySwatch: lightblue,
    splashColor: lightblue,
  */

  // sliderTheme: lightblue,

  //  buttonTheme: ButtonThemeData(te),
   // splashColor: HazizzTheme.blue,


    textTheme: TextTheme(
      body1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      body2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      title: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),
      caption: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display3: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display4: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      overline: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      subhead: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),

      subtitle: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      button: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),

    ),

  //  textTheme: TextTheme(body1: TextStyle(backgroundColor: Colors.red))


    brightness: Brightness.light,
    accentColor: red,
    // primaryColorLight: lightblue,
    primaryColorDark: blue,
    primaryColor: lightblue,
    errorColor: red,
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

  static final ThemeData darkThemeData = new ThemeData(
    /*
    hoverColor: lightblue,
    indicatorColor: lightblue,
    //  pageTransitionsTheme: lightblue,
   // primarySwatch: lightblue,
    splashColor: lightblue,
*/
    textTheme: TextTheme(
      body1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      body2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      title: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),
      caption: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display3: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display4: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      overline: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      subhead: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      display1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),

      subtitle: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      button: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),
    ),
    brightness: Brightness.dark,
    accentColor: red,
    // primaryColorLight: lightblue,


    primaryColorDark: Color.fromRGBO(70, 105, 140, 1),
    primaryColor: Color.fromRGBO(14, 105, 138, 1),

    /*
    primaryColorDark: blue,
    primaryColor: lightblue,
    */

    errorColor: red,
 //   textSelectionHandleColor: Colors.black,
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





  static const String _key_theme = "_key_theme";

  static const String _value_dark = "dark";
  static const String _value_light = "light";


  static Future<bool> isDark() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String theme = sharedPreferences.getString(_key_theme);
    if(theme == _value_dark){
      return true;
    }
    return false;
  }

  static Future<bool> isLight() async {
    return !(await isDark());
  }

  static Future<void> setDark() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_key_theme, _value_dark);
  }
  static Future<void> setLight() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_key_theme, _value_light);
  }


  static Future<ThemeData> getCurrentTheme() async {
    if(await isDark()) {
      return HazizzTheme.darkThemeData;
    }else{
      return HazizzTheme.lightThemeData;

    }
  }








}