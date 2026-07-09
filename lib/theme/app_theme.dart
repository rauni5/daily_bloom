import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF1F4EC),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C6B54)),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF15201A),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4C6B54),
      brightness: Brightness.dark,
    ),
  );
}
