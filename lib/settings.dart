import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/preferences.dart';
import 'package:horse_app/theme.dart';
import 'package:horse_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        drawer: appDrawer(context, '/settings'),
        body: Column(children: <Widget>[
          // ListTile(
          //     title: const Text('Download CSVs'),
          //     subtitle: const Text(
          //         'Export the database to CSV format to be used anywhere else'),
          //     isThreeLine: true,
          //     leading: const Icon(Icons.file_download),
          //     onTap: () async {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           duration: const Duration(minutes: 10),
          //           content: Row(
          //             children: const [
          //               Padding(
          //                   padding: EdgeInsets.only(right: 30),
          //                   child: CircularProgressIndicator()),
          //               Text("Saving..."),
          //             ],
          //           ),
          //         ),
          //       );

          //       // var csvs = await DB.exportToCSV();
          //       // var horses = csvs[Tables.horses]!;
          //       // var events = csvs[Tables.events]!;

          //       // Directory tempDir = await getTemporaryDirectory();
          //       // String tempHorsesPath = tempDir.path + '/horses.csv';
          //       // File(tempHorsesPath).writeAsString(horses);

          //       // String tempEventsPath = tempDir.path + '/events.csv';
          //       // File(tempEventsPath).writeAsString(events);

          //       // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //       // await Share.shareFiles([tempHorsesPath, tempEventsPath],
          //       //     mimeTypes: ['text/csv', 'text/csv']);
          //       showSuccess(context, "Files saved!");
          //     }),
          // const Divider(
          //   indent: 10,
          //   endIndent: 10,
          //   thickness: 1,
          // ),
          // ListTile(
          //     title: const Text('Load CSVs'),
          //     subtitle: const Text(
          //         'Load previously exported CSVs back into the database. Use with caution, data may be overwritten.'),
          //     isThreeLine: true,
          //     leading: const Icon(Icons.file_upload),
          //     onTap: () async {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           duration: const Duration(minutes: 10),
          //           content: Row(
          //             children: const [
          //               Padding(
          //                   padding: EdgeInsets.only(right: 30),
          //                   child: CircularProgressIndicator()),
          //               Text("Saving..."),
          //             ],
          //           ),
          //         ),
          //       );

          //       // var csvs = await DB.exportToCSV();
          //       // var horses = csvs[Tables.horses]!;
          //       // var events = csvs[Tables.events]!;

          //       // Directory tempDir = await getTemporaryDirectory();
          //       // String tempHorsesPath = tempDir.path + '/horses.csv';
          //       // File(tempHorsesPath).writeAsString(horses);

          //       // String tempEventsPath = tempDir.path + '/events.csv';
          //       // File(tempEventsPath).writeAsString(events);

          //       // ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //       // await Share.shareFiles([tempHorsesPath, tempEventsPath],
          //       //     mimeTypes: ['text/csv', 'text/csv']);
          //       // showSuccess(context, "Files saved!");
          //     }),
          Consumer(
            builder: (context, ref, child) {
              final theme = ref.watch(appThemeProvider);
              final themeStr = theme == ThemeMode.system
                  ? "System"
                  : theme == ThemeMode.light
                      ? "Light"
                      : "Dark";

              return ListTile(
                title: const Text('Theme'),
                subtitle: Text(themeStr),
                leading: const Icon(Icons.palette),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          ThemePickerDialog(currentTheme: theme, ref: ref));
                },
              );
            },
          )
        ]));
  }
}

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog(
      {Key? key, required this.currentTheme, required this.ref})
      : super(key: key);

  final ThemeMode currentTheme;
  final WidgetRef ref;

  _updateTheme(BuildContext context, ThemeMode theme) {
    ref.read(appThemeProvider.notifier).state = theme;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Theme'),
      children: <Widget>[
        RadioListTile<ThemeMode>(
          value: ThemeMode.light,
          groupValue: currentTheme,
          onChanged: (_) => _updateTheme(context, ThemeMode.light),
          title: const Text('Light'),
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.dark,
          groupValue: currentTheme,
          onChanged: (_) => _updateTheme(context, ThemeMode.dark),
          title: const Text('Dark'),
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.system,
          groupValue: currentTheme,
          onChanged: (_) => _updateTheme(context, ThemeMode.system),
          title: const Text('System'),
        ),
      ],
    );
  }
}
