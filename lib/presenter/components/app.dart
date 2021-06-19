import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  final primaryColor = Color.fromRGBO(136, 14, 79, 1);
  final primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Couse Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: _appTheme,
      home: LoginPage(),
    );
  }

  ThemeData get _appTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      accentColor: primaryColor,
      backgroundColor: Colors.white,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      textSelectionTheme: _textSelectionTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  TextTheme get _textTheme {
    return TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
      ),
    );
  }

  TextSelectionThemeData get _textSelectionTheme {
    return TextSelectionThemeData(
      cursorColor: primaryColor,
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      focusColor: primaryColor,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColorLight,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColorDark,
        ),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColorLight,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red[400]!,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[400]!,
        ),
      ),
      alignLabelWithHint: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        overlayColor: MaterialStateProperty.all<Color>(primaryColorLight),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    );
  }

  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        overlayColor: MaterialStateProperty.all<Color>(primaryColorLight),
        foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
      ),
    );
  }
}
