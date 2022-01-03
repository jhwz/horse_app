import 'dart:collection';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/events/add_event_dialog.dart';
import 'package:horse_app/events/types/noop.dart';
import 'package:horse_app/events/types/types.dart';
import 'package:horse_app/notifications.dart';
import 'package:horse_app/utils/icon_text.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';

import 'package:reactive_forms/reactive_forms.dart';

import '../utils/utils.dart';
import "../state/db.dart";

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
  bool _selectAllHorses = false;

  FormGroup form = FormGroup({});
  Widget? widgetsForForm;

  Future<void> _createEvent() async {
    if (_horses.isNotEmpty) {
      Map<String, dynamic> map = Map.from(form.value);
      final eventTime = map["date"] as DateTime;
      final notes = map["notes"] is String ? map["notes"] as String : null;
      map.remove("date");
      map.remove("notes");

      // create a unique event for each horse
      List<EventsCompanion> events = _horses
          .map((h) => EventsCompanion(
                date: Value(eventTime),
                registrationName: Value(h.registrationName),
                type: Value(event.type),
                notes: Value(notes),
                extra: Value(map),
              ))
          .toList();

      // add all the events to the database
      await Future.wait(events.map((e) => db.createEvent(e)));

      // if this is a special event, create some actions from it.
      for (var h in _horses) {
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
    Navigator.pop(context);
  }

  Future<bool> _loadHorses() async {
    if (_allHorses.isNotEmpty) {
      return true;
    }
    var horses = await db.listHorses();
    setState(() {
      _allHorses = horses;
    });
    return true;
  }

  void _constructForm(ET event) {
    Map<String, AbstractControl<dynamic>> controls = {
      'notes': FormControl<String>(),
      'date': FormControl<DateTime>(value: DateTime.now()),
      ...event.fields(null),
    };
    List<Widget> children = [
      ReactiveDateTimePicker(
        formControlName: 'date',
        type: ReactiveDatePickerFieldType.dateTime,
        timePickerEntryMode: TimePickerEntryMode.input,
        decoration: const InputDecoration(
          labelText: 'Time of event (defaults to now)',
        ),
      ),
      ReactiveTextField(
        formControlName: 'notes',
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Event notes (optional)',
        ),
      ),
      ...event.formFields(),
    ];

    form = FormGroup(controls);

    widgetsForForm = ReactiveForm(
      formGroup: form,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children
            .map((w) =>
                Padding(padding: const EdgeInsets.only(top: 8), child: w))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      bottomNavigationBar: _index == 1
          ? Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 24.0),
              child: ElevatedButton(
                onPressed: _horses.isNotEmpty
                    ? () {
                        setState(() {
                          _index += 1;
                        });
                      }
                    : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Select and next'),
                ),
              ),
            )
          : _index == 2
              ? ReactiveForm(
                  formGroup: form,
                  child: CreateEventSubmitButton(
                    formGroup: form,
                    createEvent: _createEvent,
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
                                    value: _horses.any((h2) =>
                                        h2.registrationName ==
                                        h.registrationName),
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
                                          _horses.removeWhere((h2) =>
                                              h2.registrationName ==
                                              h.registrationName);
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
            content: widgetsForForm ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class CreateEventSubmitButton extends StatelessWidget {
  final FormGroup formGroup;
  final Function createEvent;

  const CreateEventSubmitButton({
    Key? key,
    required this.formGroup,
    required this.createEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 24.0),
      child: ElevatedButton(
        onPressed: !form!.valid
            ? null
            : () async {
                // create the event
                try {
                  await createEvent();
                  showInfo(context, 'Event created!');
                } catch (e) {
                  showError(context, "Failed to create event: ${e.toString()}");
                }
              },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Create Event'),
        ),
      ),
    );
  }
}

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
