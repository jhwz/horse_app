import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'events/list.dart';
import 'horses/list.dart';
import 'settings.dart';
import 'state/db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  print("init");
  DB = AppDb();
  print("start");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: "/events",
      onGenerateRoute: (settings) {
        // logs page, also the default
        if (settings.name == null || settings.name == '/events') {
          return MaterialPageRoute(builder: (context) => const EventsPage());
        }

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
