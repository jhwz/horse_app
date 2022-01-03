import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/notifications.dart';
import 'package:horse_app/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'events/list.dart';
import 'horses/list.dart';
import 'settings.dart';
import 'state/db.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize our bits and pieces
  final awaited = await Future.wait([
    SharedPreferences.getInstance(),
    initNotificatons(),
  ]);
  final sharedPrefs = awaited[0] as SharedPreferences;

  db = AppDb();
  runApp(
    ProviderScope(
      child: const App(),
      overrides: [
        preferences.overrideWithValue(sharedPrefs),
      ],
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);

    return MaterialApp(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeMode,
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
