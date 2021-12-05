import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:horse_app/events/types/types.dart';
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
  late ET event;
  final List<Horse> _horses = [];
  List<Horse> _allHorses = [];
  bool _selectAllHorses = false;

  FormGroup form = FormGroup({});
  Widget? widgetsForForm;

  Future<void> _createEvent() async {
    if (_horses.isNotEmpty) {
      // create a unique event for each horse
      List<EventsCompanion> events = _horses.map<EventsCompanion>((h) {
        var map = form.value;
        var e = EventsCompanion(
          date: Value(map["date"] as DateTime),
          registrationName: Value(h.registrationName),
          type: Value(event.type),
          notes: Value(map["notes"] is String ? map["notes"] as String : null),
        );

        return e;
      }).toList();

      // add all the events to the database
      await Future.wait(events.map((e) => DB.createEvent(e)));

      // if this is a special event, create some actions from it.
      if (event.type == ET.foaling.type) {
        for (var h in _horses) {
          try {
            event.onCreate(h);
          } catch (e) {
            showError(context, "Something went wrong: $e");
          }
        }
      }
    }
    Navigator.pop(context);
  }

  Future<bool> _loadHorses() async {
    if (_allHorses.isNotEmpty) {
      return true;
    }
    var horses = await DB.listHorses();
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
        controlsBuilder: (context,
            {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
          return const SizedBox.shrink();
        },
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
            title: Text(_index == 0 ? 'Event Type' : formatStr(event.type)),
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

class Step1 extends StatelessWidget {
  final void Function(ET) onTap;

  const Step1({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          child: Text('Select the event type'),
          padding: EdgeInsets.only(bottom: 8.0)),
      ...ET.types
          .map(
            (e) => Container(
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
                title: Text(formatStr(e.type)),
                onTap: () => onTap(e),
              ),
            ),
          )
          .toList()
    ]);
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
