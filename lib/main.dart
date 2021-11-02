import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './logs.dart';
import './horses.dart';
import './settings.dart';
import './db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DB.init().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whitehall Gypsy Cobs',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          isDense: true,
        ),
        fontFamily: GoogleFonts.montserrat().fontFamily,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: "/logs",
      onGenerateRoute: (settings) {
        // logs page, also the default
        if (settings.name == null || settings.name == '/logs') {
          return MaterialPageRoute(builder: (context) => const LogsPage());
        }

        // horses page
        if (settings.name == '/horses') {
          return MaterialPageRoute(builder: (context) => const HorsesPage());
        }
        if (settings.name == '/settings') {
          return MaterialPageRoute(builder: (context) => const SettingsPage());
        }
      },
    );
  }
}
