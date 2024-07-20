import 'package:expense_tracker/constant/theme/palette.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final ThemeData myTheme = ThemeData(
    scaffoldBackgroundColor: Palette.backgroundColor,
    primaryColor: Palette.gradient1,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: _border(Palette.borderColor),
      focusedBorder: _border(Palette.gradient2),
      errorBorder: _border(Palette.errorColor),
      focusedErrorBorder: _border(Palette.errorColor),
      border: _border(Palette.borderColor),
      labelStyle: const TextStyle(color: Palette.whiteColor),
      hintStyle: const TextStyle(color: Palette.greyColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.gradient1,
      titleTextStyle: TextStyle(
        color: Palette.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Palette.whiteColor,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white),
    ).apply(
      bodyColor: Colors.white, // Apply white color to body text
      displayColor: Colors.white, // Apply white color to display text
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Palette.gradient2,
      foregroundColor: Palette.whiteColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Palette.gradient2,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(
      color: Palette.whiteColor,
    ),
    dividerColor: Palette.greyColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.backgroundColor,
      selectedItemColor: Palette.gradient2,
      unselectedItemColor: Palette.inactiveBottomBarItemColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Palette.gradient1),
        foregroundColor: WidgetStateProperty.all(Palette.whiteColor),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 34),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}