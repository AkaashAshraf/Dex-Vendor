import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor:
        Color(0xffED8437), //active bottom nav, CircularProgressIndicator,
    accentColor: Color(0xff707070), //inactive bottom nav
    hintColor: Colors.grey[500], //text filed background,
    buttonColor: Color(0xff000000),
    secondaryHeaderColor: Color(0xffed8437), // secondary color
    fontFamily: 'JF-Flat',
    scaffoldBackgroundColor: Colors.white,
    sliderTheme: SliderThemeData.fromPrimaryColors(
        primaryColor: Colors.black,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.black,
        valueIndicatorTextStyle: TextStyle(color: Colors.black)),
    primaryTextTheme: TextTheme(subtitle1: TextStyle(color: Colors.black)),
    accentTextTheme: TextTheme(subtitle1: TextStyle(color: Color(0xffed8437))),
  );
}
