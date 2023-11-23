import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tamrini/utils/constants.dart';

import 'styles.dart';

ThemeData darkTheme = ThemeData(
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey[700],
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: const TextStyle(
      fontFamily: "cairo",
      color: Colors.white,
      fontSize: 16,
    ),
  ),
  timePickerTheme: const TimePickerThemeData(
      dialTextColor: Colors.white,
      hourMinuteTextColor: Colors.white,
      dayPeriodTextColor: Colors.white),

  primarySwatch: kPrimaryColor,
  cupertinoOverrideTheme: const CupertinoThemeData(
    brightness: Brightness.dark,
  ),

  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.light),
    backgroundColor: kSecondaryColor!,
    elevation: 1.0,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: "cairo",
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kSecondaryColor!,
      elevation: 10.0,
      backgroundColor: kSecondaryColor!,
      unselectedItemColor: Colors.grey),
  bottomAppBarTheme: BottomAppBarTheme(
      color: HexColor('333739'),
      shape: const CircularNotchedRectangle(),
      elevation: 3.0),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontFamily: "cairo",
      color: Colors.white,
      fontSize: 16.0,
    ),
    bodySmall: TextStyle(fontFamily: "cairo", color: Colors.white60),
    bodyLarge: TextStyle(
        fontFamily: "cairo",

        // fontSize: 18,
        fontWeight: FontWeight.normal,
        color: Colors.white),
    bodyMedium: TextStyle(
        fontFamily: "cairo",
        // fontSize: 18,
//        fontWeight: FontWeight.bold,
        color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    prefixIconColor: Colors.white,
    labelStyle: TextStyle(fontFamily: "cairo", color: Colors.white),
    hintStyle: TextStyle(fontFamily: "cairo", color: Colors.white60),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white38),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white),

  indicatorColor: Colors.white,
  scaffoldBackgroundColor: HexColor('1f2030'), //000000   //1f2030s
  cardColor: HexColor('252a34'), //404040      //2b3456
  secondaryHeaderColor: HexColor('2b3456'), //272727
  canvasColor: HexColor('252a34'),

  // border
  disabledColor: HexColor('252a34'),
  dialogBackgroundColor: Colors.black87,
);

ThemeData lightTheme = ThemeData(
  primarySwatch: kPrimaryColor,
  cupertinoOverrideTheme: const CupertinoThemeData(
    brightness: Brightness.light,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: kSecondaryColor!,
    ),
    backgroundColor: kSecondaryColor!,
    elevation: 0.0,
    iconTheme: const IconThemeData(
      color: Colors.black87,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: "cairo",
      color: Colors.black87,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: kSecondaryColor!,
    backgroundColor: kSecondaryColor!,
    elevation: 10.0,
    showSelectedLabels: false,
    showUnselectedLabels: false,
  ),
  textTheme: TextTheme(
    subtitle1: const TextStyle(
      fontFamily: "cairo",
      color: Colors.black,
      fontSize: 16.0,
    ),
    headline5: bigTitles.headline5,
    bodyText2: const TextStyle(
        fontFamily: "cairo",
        fontWeight: FontWeight.bold,
        color: Colors.black87),
    bodyText1: const TextStyle(
        fontFamily: "cairo",
        fontWeight: FontWeight.w400,
        color: Colors.black87),
    caption: const TextStyle(fontFamily: "cairo", color: Colors.black54),
  ),

  fontFamily: 'cairo',
  cardColor: Colors.white,
  secondaryHeaderColor: Colors.white,
  indicatorColor: Colors.black,
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.grey.shade900),
  dialogBackgroundColor: Colors.white,

  // border
  disabledColor: Colors.grey.shade300,
);
