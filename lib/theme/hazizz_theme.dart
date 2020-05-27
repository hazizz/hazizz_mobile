import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData theme(BuildContext context){
  return Theme.of(context);
}

class HazizzTheme{

  static ThemeData currentTheme = lightThemeData;
  static bool currentThemeIsDark = false;

  static const Color
  red = Color.fromRGBO(242, 59, 80, 1),
  yellow = Color.fromRGBO(255, 202, 4, 1),
  white = Color.fromRGBO(232, 240, 223, 1),
  lightblue = Color.fromRGBO(73, 216, 216, 1),
  blue = Color.fromRGBO(54, 177, 191, 1),
  purple = Color.fromRGBO(126, 1, 255, 1),

  kreta_blue = Color.fromRGBO(47, 168, 202, 1),


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
  assignmentColor = yellow,
  kreta_homeworkColor = kreta_blue;

  static final Color formColor = Colors.grey.withAlpha(120);


  static Color get warningColor => red;

  static final ThemeData lightThemeData = new ThemeData(
    textTheme: TextTheme(
      bodyText2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600,),
      bodyText1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline6: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),
      caption:   TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline3: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline5: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      overline:  TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      subtitle1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline4: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      subtitle2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      button:    TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),

    ),

    brightness: Brightness.light,
    accentColor: red,
    primaryColorDark: blue,
    primaryColor: lightblue,
    errorColor: red,
  );

  static final ThemeData darkThemeData = new ThemeData(
      textTheme: TextTheme(
      bodyText2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600, ),
      bodyText1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline6: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),
      caption:   TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline3: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline5: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      overline:  TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      subtitle1: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      headline4: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      subtitle2: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
      button:    TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800),
    ),
    brightness: Brightness.dark,
    accentColor: red,
    primaryColorDark: Color.fromRGBO(70, 105, 140, 1),
    primaryColor: Color.fromRGBO(14, 105, 138, 1),

    errorColor: red,
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
    currentThemeIsDark = true;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_key_theme, _value_dark);
  }
  static Future<void> setLight() async {
    currentThemeIsDark = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_key_theme, _value_light);
  }

  static Future<ThemeData> getCurrentTheme() async {
    if(await isDark()) {
      currentThemeIsDark = true;
      currentTheme = HazizzTheme.darkThemeData;
      return currentTheme;
    }else{
      currentThemeIsDark = false;
      currentTheme = HazizzTheme.lightThemeData;

      return currentTheme;
    }
  }
}