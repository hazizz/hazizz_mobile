import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



ThemeData theme(BuildContext context){
  return Theme.of(context);
}

class HazizzTheme{

  static final Color
  red = Color.fromRGBO(242, 59, 80, 1),
  yellow = Color.fromRGBO(255, 202, 4, 1),
  white = Color.fromRGBO(232, 240, 223, 1),
  lightblue = Color.fromRGBO(73, 216, 216, 1),
  blue = Color.fromRGBO(54, 177, 191, 1),




  grade5Color = Colors.green,
  grade4Color = Colors.lightGreenAccent,
  grade3Color = Colors.yellowAccent,
  grade2Color = Colors.orange,
  grade1Color = Colors.red,
  gradeNeutralColor = Colors.black,


  headerColor = Colors.red,
  homeworkColor = Colors.green,
  testColor = Colors.red,
  oralTestColor = Colors.purple,
  assignmentColor = Colors.yellow,

  formColor = Colors.grey.withAlpha(120);


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

    textTheme: TextTheme(
      subtitle: TextStyle(color: Colors.black38),
      button: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14.0,
      ),
    ),

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
      subtitle: TextStyle(color: Colors.white30),
      button: TextStyle(
        //  fontFamily: 'Montserrat',
          fontSize: 16.0,
      ),
    ),
    brightness: Brightness.dark,
    accentColor: red,
    // primaryColorLight: lightblue,
    primaryColorDark: Color.fromRGBO(14, 105, 138, 1),
    primaryColor: Color.fromRGBO(70, 105, 140, 1),
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