import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:horse_app/events/types/types.dart';

import 'package:horse_app/reactive/validators.dart';
import 'package:horse_app/utils/gallery.dart';
import 'package:horse_app/utils/notes.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';

import 'package:reactive_forms/reactive_forms.dart';

import "../state/db.dart";

class DateFormField extends StatelessWidget {
  const DateFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveDateTimePicker(
      formControlName: 'date',
      type: ReactiveDatePickerFieldType.dateTime,
      timePickerEntryMode: TimePickerEntryMode.input,
      decoration: const InputDecoration(
        labelText: 'Time',
        prefixIcon: Icon(Icons.schedule_outlined),
      ),
    );
  }
}

class CostFormField extends StatelessWidget {
  const CostFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      keyboardType: TextInputType.number,
      formControlName: 'cost',
      validationMessages: (control) =>
          {ValidationMessage.number: "Cost must be a number"},
      decoration: const InputDecoration(
        labelText: 'Cost',
        prefixIcon: Icon(Icons.attach_money_outlined),
      ),
    );
  }
}

class EventNotesListTile extends StatelessWidget {
  final Function(String s) onChange;
  final String value;

  const EventNotesListTile(
      {Key? key, required this.value, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(value),
      leading: const Icon(Icons.note_alt_outlined),
      title: const Text('Notes'),
      subtitle: value != ""
          ? Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : const Text("Enter notes..."),
      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
      onTap: () async {
        var newNotes = await Navigator.push<String?>(
          context,
          MaterialPageRoute(
            builder: (context) => EditNotePage(
              note: value,
            ),
          ),
        );
        if (newNotes != null) {
          onChange(newNotes);
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}

class EventGalleryListTile extends StatelessWidget {
  final Future<List<Photo>> Function(int offset, int limit) fetch;
  final Future<Photo> Function(Uint8List) onAdd;
  final Function(int) onDelete;
  final int? primaryPhotoId;

  const EventGalleryListTile({
    Key? key,
    required this.fetch,
    required this.onAdd,
    required this.onDelete,
    this.primaryPhotoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: primaryPhotoId == null
          ? const Icon(Icons.image)
          : FutureBuilder(
              future: db.getEventPhotos(ids: [primaryPhotoId!]),
              builder:
                  (context, AsyncSnapshot<List<EventGalleryData>> snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Image.memory(
                    snapshot.data!.first.photo,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  );
                } else {
                  return const Icon(Icons.image);
                }
              },
            ),
      title: const Text('Images'),
      subtitle: const Text('Event specific photos'),
      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Gallery(
              fetch: fetch,
              onAdd: onAdd,
              onDelete: onDelete,
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}
