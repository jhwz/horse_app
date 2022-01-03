import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/preferences.dart';
import 'package:horse_app/utils/utils.dart';

const defaultEvents = [
  "feed",
  "farrier",
  "vet",
  "dentist",
];

final customEventsProvider =
    StateNotifierProvider<PreferencesNotifier<List<String>>, List<String>>(
  (ref) => PreferencesNotifier(
    "customEvents",
    ref,
    (prefs, key) => prefs.getStringList(key) ?? defaultEvents,
    (prefs, key, value) => prefs.setStringList(key, value),
    defaultEvents,
  ),
);

class AddEventDialog extends ConsumerStatefulWidget {
  const AddEventDialog({Key? key}) : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends ConsumerState<AddEventDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Custom Event"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: "Enter Event Name...",
        ),
        autofocus: true,
        
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Add"),
          onPressed: () {
            final text = toCamelCase(_controller.text);
            List<String> events = List.from(ref.read(customEventsProvider))
              ..add(text);
            ref.read(customEventsProvider.notifier).state = events;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
