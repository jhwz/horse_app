import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/events/create.dart';
import 'package:horse_app/events/form_widgets.dart';
import 'package:horse_app/events/types/noop.dart';
import 'package:horse_app/events/types/types.dart';
import 'package:horse_app/horses/list_item.dart';
import 'package:horse_app/horses/single.dart';
import 'package:horse_app/utils/component_actions.dart';
import 'package:drift/drift.dart' show Value;
import 'package:horse_app/utils/gallery.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../utils/utils.dart';
import "../state/db.dart";

class EventSummaryPage extends ConsumerStatefulWidget {
  final EventHorse event;

  const EventSummaryPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventSummaryPageState createState() => _EventSummaryPageState();
}

class _EventSummaryPageState extends ConsumerState<EventSummaryPage> {
  late Event e;
  late ET et;

  late FormGroup form;

  @override
  void initState() {
    super.initState();
    e = widget.event.meta.copyWith();
    et = ref.read(allEvents).firstWhere((ET et) => et.type == e.type,
        orElse: () => NoopEvent(e.type));

    form = formGroupFromEvent(widget.event.meta);
    form.addAll(et.fields(widget.event.meta.extra));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          final companion = updateEventWithForm(e.toCompanion(true), form);
          await handle(context, db.updateEvent(companion));
        } catch (e) {
          print("event update failed: $e");
        }
        Navigator.pop(context, ComponentAction.change);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.event.meta.formattedType),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) async {
                if (value == 'Delete') {
                  try {
                    await db.deleteEvent(widget.event.meta.id);
                    showSuccess(context, 'Deleted');
                    Navigator.pop(context, ComponentAction.delete);
                  } catch (e) {
                    showError(context, 'Deleting failed: ${e.toString()}');
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                HorseListItem(
                  horse: widget.event.horse,
                  onTap: (Horse h) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HorseProfilePage(horse: widget.event.horse),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: DateFormField(),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      top: 8.0, bottom: 16.0, left: 16.0, right: 16.0),
                  child: CostFormField(),
                ),
                ...et.formFields().map((e) => Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, right: 16.0),
                      child: e,
                    )),
                EventNotesListTile(
                  value: e.notes ?? "",
                  onChange: (String newNotes) => setState(() {
                    e = e.copyWith(notes: Value(newNotes));
                  }),
                ),
                EventGalleryListTile(
                  primaryPhotoId:
                      e.images?.isNotEmpty ?? false ? e.images![0] : null,
                  fetch: (offset, limit) async {
                    if (e.images == null || e.images!.isEmpty) {
                      return [];
                    }

                    final ids = e.images!.sublist(
                        offset,
                        offset + limit > e.images!.length
                            ? e.images!.length
                            : offset + limit);

                    return (await db.getEventPhotos(ids: ids))
                        .map((e) => Photo(id: e.id, photo: e.photo))
                        .toList();
                  },
                  onAdd: (data) async {
                    final galleryData = await db.addEventPhoto(photo: data);
                    e = e.copyWith(
                        images: Value((e.images ?? [])..add(galleryData.id)));
                    return Photo(id: galleryData.id, photo: galleryData.photo);
                  },
                  onDelete: (int id) async {
                    setState(() {
                      e = e.copyWith(
                          images:
                              Value(e.images!.where((i) => i != id).toList()));
                    });
                    await db.updateEvent(e);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
