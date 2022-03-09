import 'package:flutter/material.dart';

extension DateTimeFormatting on DateTime {
  String dateTime() {
    return "${date()}, $hour:$minute";
  }

  String date() {
    return "$day/$month/${year.toString().substring(2)}";
  }

  static const dayMap = [
    'Unknown',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const monthMap = [
    'Unknown',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String dayMonthYear() {
    return '${dayMap[weekday]}, ${monthMap[month]} $year';
  }

  String monthYear() {
    return '${monthMap[month]} $year';
  }
}

extension DurationFormatting on Duration {
  String daysRelNow() {
    var d = inDays;
    if (d == 0) return 'Today';
    if (d == 1) return 'Tomorrow';
    if (d == -1) return 'Yesterday';
    if (d > 0) return '$d days from now';
    if (d < 0) return '$d days ago';
    return 'unknown';
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
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              // child: Text(
              //   'Menu',
              //   style: Theme.of(context).textTheme.headline6,
              // ),
            )),
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
          title: const Text('Profile'),
          selected: root == '/profile',
          leading: const Icon(Icons.account_circle),
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/profile", (route) => false);
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
      backgroundColor: Colors.green,
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

Future<T> handle<T>(BuildContext context, Future<T> future) async {
  try {
    return await future;
  } catch (e) {
    showError(context, e.toString());
    rethrow;
  }
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

String toCamelCase(String s) {
  String out = '';
  var uppercase = false;
  for (int i = 0; i < s.length; i++) {
    if (uppercase) {
      out += s[i].toUpperCase();
      uppercase = false;
    } else if (s[i] == '_' || s[i] == '-' || s[i] == ' ') {
      uppercase = true;
    } else {
      out += s[i].toLowerCase();
    }
  }
  return out;
}
