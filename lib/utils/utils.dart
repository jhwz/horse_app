import 'package:flutter/material.dart';

extension DateTimeFormatting on DateTime {
  String dateTime() {
    return "${date()}, $hour:$minute";
  }

  String date() {
    return "$day/$month/${year.toString().substring(2)}";
  }
}

// Helper function to return the app drawer
Drawer appDrawer(BuildContext context, String root) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
            child: null),
        ListTile(
          title: const Text('Events'),
          selected: root == '/events',
          leading: const Icon(Icons.list),
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/events", (route) => false);
          },
        ),
        ListTile(
          title: const Text('Horses'),
          selected: root == '/horses',
          leading: const Icon(Icons.bedroom_baby),
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/horses", (route) => false);
          },
        ),
        ListTile(
          title: const Text('Settings'),
          selected: root == '/settings',
          leading: const Icon(Icons.settings),
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/settings", (route) => false);
          },
        ),
      ],
    ),
  );
}

void showSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}

void showInfo(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).errorColor,
    ),
  );
}

String formatStr(String s) {
  String out = '';
  var uppercase = true;
  for (int i = 0; i < s.length; i++) {
    if (uppercase) {
      out += s[i].toUpperCase();
      uppercase = false;
    } else if (s[i] == '_' || s[i] == '-') {
      out += ' ';
      uppercase = true;
    } else if (s[i].toUpperCase() == s[i]) {
      out += ' ';
      out += s[i];
    } else {
      out += s[i];
    }
  }
  return out;
}
