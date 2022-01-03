import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horse_app/preferences.dart';

final appThemeProvider =
    StateNotifierProvider<PreferencesNotifier<ThemeMode>, ThemeMode>(
  (ref) => PreferencesNotifier(
    "themeMode",
    ref,
    (prefs, key) => ThemeMode.values[prefs.getInt(key) ?? 0],
    (prefs, key, value) => prefs.setInt(key, value.index),
    ThemeMode.system,
  ),
);

ThemeData darkTheme() {
  return ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      //
      background: Color(0xFF363636),
      onBackground: Color(0xFFFFFFFF),
      //
      primary: Color(0xFFFF5722),
      primaryVariant: Color(0xFFFF5722),
      onPrimary: Color(0xFFFFFFFF),
      //
      secondary: Color(0xFFFF5722),
      secondaryVariant: Color(0xFFFF5722),
      onSecondary: Color(0xFFFFFFFF),
      //
      error: Color(0xFFFF0000),
      onError: Color(0xFFFFFFFF),
      //
      surface: Color(0xFF414141),
      onSurface: Color(0xFFDDDDDD),
    ),

    //
    // Typography
    //

    fontFamily: GoogleFonts.montserrat().fontFamily,

    //
    // Custom
    //

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      isDense: true,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
  );
}

ThemeData lightTheme() {
  return ThemeData(
    //
    // Color
    //
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      //
      background: Color(0xFFE7E7E7),
      onBackground: Color(0xFF121212),
      //
      primary: Color(0xFFFF5722),
      primaryVariant: Color(0xFFFF5722),
      onPrimary: Color(0xFFFFFFFF),
      //
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      //
      secondary: Color(0xFFFF5722),
      secondaryVariant: Color(0xFFFF5722),
      onSecondary: Color(0xFFFFFFFF),
      //
      surface: Color(0xFFF1F1F1),
      onSurface: Color(0xFF111111),
    ),

    //
    // Typography
    //

    fontFamily: GoogleFonts.montserrat().fontFamily,

    //
    // Custom
    //

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      isDense: true,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
  );
}

extension ColorX on Color {

  Color mute(int percent, Brightness brightness) {
    return brightness == Brightness.dark ? darken(percent) : lighten(percent);
  }

  /// Darken a color by [percent] amount (100 = black)
// ........................................................
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        alpha, (red * f).round(), (green * f).round(), (blue * f).round());
  }

  /// Lighten a color by [percent] amount (100 = white)
// ........................................................
  Color lighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(alpha, red + ((255 - red) * p).round(),
        green + ((255 - green) * p).round(), blue + ((255 - blue) * p).round());
  }
}
