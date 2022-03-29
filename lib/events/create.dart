import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/events/add_event_dialog.dart';
import 'package:horse_app/events/types/noop.dart';
import 'package:horse_app/events/types/types.dart';
import 'package:horse_app/notifications.dart';
import 'package:horse_app/reactive/validators.dart';
import 'package:horse_app/utils/gallery.dart';
import 'package:horse_app/utils/icon_text.dart';
import 'package:horse_app/utils/notes.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';

import 'package:reactive_forms/reactive_forms.dart';

import '../utils/utils.dart';
import "../state/db.dart";

Future<void> _createEvent({
  required BuildContext context,
  required FormGroup form,
  required List<Horse> horses,
  required ET event,
  required String notes,
  required List<Photo> photos,
}) async {
  try {
    if (horses.isNotEmpty) {
      Map<String, dynamic> map = Map.from(form.value);
      final eventTime = map["date"] as DateTime;
      map.remove("date");
      final cost = map["cost"] as String;
      map.remove("cost");

      // create a unique event for each horse
      List<EventsCompanion> events = horses
          .map((h) => EventsCompanion(
                date: Value(eventTime),
                cost: Value(double.tryParse(cost) ?? 0),
                horseID: Value(h.id),
                type: Value(event.type),
                notes: Value(notes),
                extra: Value(map),
              ))
          .toList();

      // add all the events to the database
      await Future.wait(events.map((e) => db.createEvent(e)));

      // if this is a special event, create some actions from it.
      for (var h in horses) {
        try {
          event.onCreate(h);
        } catch (e) {
          showError(context, "Something went wrong: $e");
        }
      }

      // asynchronously schedule notifications for the event
      () async {
        final storedEvents = await db.listEvents(
            now: eventTime.add(const Duration(minutes: 1)),
            limit: events.length);

        if (storedEvents.length == 1) {
          scheduleNotificationForEvent(
              storedEvents[0], storedEvents[0].horse.displayName);
        } else if (storedEvents.isNotEmpty) {
          scheduleNotificationForEventList(
              storedEvents[0], storedEvents.length);
        }
      }();
    }
    showInfo(context, "Event created");
  } catch (e) {
    showError(context, "Failed to create event; something went wrong");
  }
  Navigator.pop(context);
}

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  static const String _title = 'New Event';
  int _index = 0;
  ET event = NoopEvent("noEvent");
  final List<Horse> _horses = [];
  List<Horse> _allHorses = [];
  List<Photo> _images = [];
  bool _selectAllHorses = false;
  String _notes = "";

  FormGroup form = FormGroup({
    'date': FormControl<DateTime>(value: DateTime.now()),
    'cost': FormControl<String>(
        value: "0.00", validators: [CustomValidators.money]),
  });
  List<Widget>? widgetsForForm;

  Future<bool> _loadHorses() async {
    if (_allHorses.isNotEmpty) {
      return true;
    }
    var horses = await db.listHorses(limit: 1000);
    setState(() {
      _allHorses = horses;
    });
    return true;
  }

  void _constructForm(ET event) {
    form.addAll({...event.fields(null)});
    widgetsForForm = event.formFields();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        bottomNavigationBar: _index == 1
            ? Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 24.0),
                child: ElevatedButton(
                  onPressed: _horses.isNotEmpty
                      ? () async {
                          setState(() {
                            _index += 1;
                          });
                          final prevEvent = await db.lastEventOfTypeForHorse(
                              event.type, _horses.first.id);
                          form.controls["cost"]!.value =
                              prevEvent?.cost?.toStringAsFixed(2) ?? "0.00";
                        }
                      : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Select and next'),
                  ),
                ),
              )
            : _index == 2
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 24.0),
                    child: ElevatedButton(
                      onPressed: !form.valid
                          ? null
                          : () => _createEvent(
                                context: context,
                                form: form,
                                event: event,
                                horses: _horses,
                                notes: _notes,
                                photos: _images,
                              ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Create Event'),
                      ),
                    ),
                  )
                : null,
        body: Stepper(
          currentStep: _index,
          type: StepperType.horizontal,
          elevation: 7,
          controlsBuilder: (context, details) => const SizedBox.shrink(),
          onStepTapped: (int index) {
            if (index < _index) {
              setState(() {
                _index = index;
              });
            }
          },
          steps: <Step>[
            //
            // STEP 1
            //
            Step(
              isActive: _index == 0,
              state: _index == 0 ? StepState.editing : StepState.complete,
              title: Text(_index == 0 ? 'Event Type' : event.formattedType),
              content: Step1(
                onTap: (e) {
                  setState(() {
                    event = e;
                    _constructForm(e);
                    _index += 1;
                  });
                },
              ),
            ),

            //
            // STEP 2
            //
            Step(
                isActive: _index == 1,
                state: _index == 1
                    ? StepState.editing
                    : _index > 1
                        ? StepState.complete
                        : StepState.disabled,
                title: const Text('Horses'),
                content: FutureBuilder(
                  future: _loadHorses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Step2Header(
                              onSelect: (v) {
                                setState(() {
                                  _selectAllHorses = v!;
                                  if (_selectAllHorses) {
                                    _horses.addAll(_allHorses);
                                  } else {
                                    _horses.clear();
                                  }
                                });
                              },
                              isSelected: _selectAllHorses,
                              onlyOneHorse: event.onlyAppliesToOne,
                            ),
                            ..._allHorses
                                .where(event.appliesTo)
                                .map(
                                  (h) => Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Theme.of(context).dividerColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: CheckboxListTile(
                                      value: _horses.any((h2) => h2.id == h.id),
                                      title: Text(h.name),
                                      onChanged: (bool? checked) {
                                        setState(() {
                                          // if the event only applies to one horse, deselect the other horses
                                          if (checked == true &&
                                              event.onlyAppliesToOne) {
                                            _horses.clear();
                                          }
                                          if (checked == true) {
                                            _horses.add(h);
                                          } else {
                                            _horses.removeWhere(
                                                (h2) => h2.id == h.id);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                )
                                .toList()
                          ]);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )),

            //
            // STEP 3
            //
            Step(
              isActive: _index == 2,
              state: _index == 2
                  ? StepState.editing
                  : _index > 2
                      ? StepState.complete
                      : StepState.disabled,
              title: const Text('Details'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReactiveDateTimePicker(
                    formControlName: 'date',
                    type: ReactiveDatePickerFieldType.dateTime,
                    timePickerEntryMode: TimePickerEntryMode.input,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      prefixIcon: Icon(Icons.schedule_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: ReactiveTextField(
                      keyboardType: TextInputType.number,
                      formControlName: 'cost',
                      validationMessages: (control) =>
                          {ValidationMessage.number: "Cost must be a number"},
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                        prefixIcon: Icon(Icons.attach_money_outlined),
                      ),
                    ),
                  ),
                  if (widgetsForForm != null)
                    ...widgetsForForm!.map((e) => Padding(
                        padding: const EdgeInsets.only(top: 8.0), child: e)),
                  ListTile(
                    key: Key(_notes),
                    leading: const Icon(Icons.note_alt_outlined),
                    title: const Text('Notes'),
                    subtitle: _notes != ""
                        ? Text(
                            _notes,
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
                            note: _notes,
                          ),
                        ),
                      );
                      if (newNotes != null) {
                        setState(() {
                          _notes = newNotes;
                        });
                      }
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    subtitle: const Text('Collection of photos'),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () async {
                      var next = await Navigator.push<Horse>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Gallery(
                            fetch: (offset, limit) async {
                              return _images.sublist(
                                  offset,
                                  (offset + limit > _images.length)
                                      ? _images.length
                                      : offset + limit);
                            },
                            onAdd: (data) async {
                              final photo =
                                  Photo(id: _images.length, photo: data);
                              setState(() {
                                _images.add(photo);
                              });
                              return photo;
                            },
                            onDelete: (int id) async {
                              setState(() {
                                _images.removeAt(id);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider that lists all of the available events for the
// application. This is the union of our defined events and
// the ones the users add.
final allEvents = Provider<List<ET>>((ref) {
  final noops = ref.watch(customEventsProvider);
  List<ET> events = List.from(ET.types)
    ..addAll(noops.map((name) => NoopEvent(name)))
    ..sort((a, b) => a.type.compareTo(b.type));
  return events;
});

class Step1 extends ConsumerWidget {
  final void Function(ET) onTap;

  const Step1({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select the event type'),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddEventDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: const TextIcon("new", Icons.add),
              ),
            ],
          ),
          padding: const EdgeInsets.only(bottom: 8.0),
        ),
        for (final e in ref.watch(allEvents))
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: ListTile(
              visualDensity: VisualDensity.comfortable,
              title: Text(e.formattedType),
              onTap: () => onTap(e),
            ),
          ),
      ],
    );
  }
}

class Step2Header extends StatelessWidget {
  final void Function(bool?) onSelect;
  final bool isSelected;
  final bool onlyOneHorse;

  const Step2Header({
    Key? key,
    required this.onSelect,
    required this.isSelected,
    required this.onlyOneHorse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(onlyOneHorse
            ? 'Select a horse for the event'
            : 'Select relevant horses'),
        onlyOneHorse
            ? const SizedBox.shrink()
            : Checkbox(value: isSelected, onChanged: onSelect)
      ]),
      padding: const EdgeInsets.only(bottom: 8.0),
    );
  }
}
