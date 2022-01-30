import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primary = Color(0xff1CAFDD);
const Color err = Color(0xffFF7A7A);
const Color background = Color(0xff44506C);

ThemeData buildTheme() {
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primary,
    secondary: primary,
  );

  final ThemeData base = ThemeData.dark().copyWith(
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: Colors.white),
      scaffoldBackgroundColor: background,
      inputDecorationTheme:
          const InputDecorationTheme(prefixIconColor: primary),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(primary),
      ),
      errorColor: err);

  return base;
}
