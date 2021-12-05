import 'package:flutter/material.dart';

import 'events/list.dart';
import 'horses/list.dart';
import 'settings.dart';
import 'state/db.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DB = AppDb();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
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
