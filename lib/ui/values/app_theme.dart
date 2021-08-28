import 'package:flutter/material.dart';

abstract class AppTheme {
  static const _primaryColor = Color.fromRGBO(136, 14, 79, 1);
  static const _primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  static const _primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  static const _secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: _primaryColor,
      primaryColorDark: _primaryColorDark,
      primaryColorLight: _primaryColorLight,
      secondaryHeaderColor: _secondaryColorDark,
      accentColor: _primaryColor,
      backgroundColor: Colors.white,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      textSelectionTheme: _textSelectionTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: _primaryColorDark,
      ),
    );
  }

  static TextSelectionThemeData get _textSelectionTheme {
    return TextSelectionThemeData(
      cursorColor: _primaryColor,
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      focusColor: _primaryColor,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: _primaryColorLight,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: _primaryColorDark,
        ),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: _primaryColorLight,
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

  static ElevatedButtonThemeData get _elevatedButtonTheme {
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
        backgroundColor: MaterialStateProperty.all<Color>(_primaryColor),
        overlayColor: MaterialStateProperty.all<Color>(_primaryColorLight),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        overlayColor: MaterialStateProperty.all<Color>(_primaryColorLight),
        foregroundColor: MaterialStateProperty.all<Color>(_primaryColor),
      ),
    );
  }
}
