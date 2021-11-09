import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';

import '../_utils.dart';
import "../state/db.dart";

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewEventPageState();
}

// This is disgusting...
class _NewEventPageState extends State<NewEventPage> {
  static const String _title = 'New Event';
  int _index = 0;
  String _type = '';
  final List<Horse> _horses = [];
  List<Horse> _allHorses = [];
  bool _selectAllHorses = false;
  static final Set<String> _eventCanOnlyHaveOneHorse = {
    EventType.foaling,
    EventType.pregnancyScans,
  };

  FormGroup form = FormGroup({});
  Widget? widgetsForForm;

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

  static final RegExp numberRegex = RegExp(r'^-?[0-9]+$');
  Map<String, dynamic>? optionalNumber(AbstractControl<dynamic> control) {
    return (control.value != null) &&
            !numberRegex.hasMatch(control.value.toString())
        ? <String, dynamic>{ValidationMessage.number: true}
        : null;
  }

  void _constructForm(String _type) {
    Map<String, AbstractControl<dynamic>> controls = {
      'notes': FormControl<String>()
    };
    List<Widget> children = [
      ReactiveTextField(
        formControlName: 'notes',
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Event notes (optional)',
        ),
      ),
    ];
    switch (_type) {
      case 'drench':
        controls[EventsTable.drench_type] =
            FormControl<String>(validators: [Validators.required]);
        children.add(ReactiveTextField(
          formControlName: EventsTable.drench_type,
          decoration: const InputDecoration(
            labelText: 'Drench Type',
          ),
        ));
        break;

      case EventType.miteTreatment:
        controls[EventsTable.miteTreatment_type] =
            FormControl<String>(validators: [Validators.required]);
        children.add(ReactiveTextField(
          formControlName: EventsTable.miteTreatment_type,
          decoration: const InputDecoration(
            labelText: 'Treatment Type',
          ),
        ));
        break;

      case EventType.foaling:
        controls[EventsTable.foaling_foalColour] =
            FormControl<String>(validators: [Validators.required]);
        controls[EventsTable.sireRegistrationName] =
            FormControl<String>(validators: [Validators.required]);
        controls[EventsTable.foaling_foalSex] =
            FormControl<Sex>(validators: [Validators.required]);

        children.addAll([
          ReactiveTextField(
            formControlName: EventsTable.foaling_foalColour,
            decoration: const InputDecoration(
              labelText: 'Foal Colour',
            ),
          ),
          ReactiveTextField(
            formControlName: EventsTable.sireRegistrationName,
            decoration: const InputDecoration(
              labelText: 'Sire Registration Name',
            ),
          ),
          ReactiveDropdownField(
            formControlName: EventsTable.foaling_foalSex,
            items: const [
              DropdownMenuItem(value: Sex.female, child: Text('Female')),
              DropdownMenuItem(value: Sex.male, child: Text('Male')),
            ],
            decoration: const InputDecoration(
              labelText: 'Sex',
              helperText: '',
            ),
          ),
        ]);
        break;

      case EventType.pregnancyScans:
        controls[EventsTable.pregnancy_inFoal] = FormControl<bool>();
        controls[EventsTable.pregnancy_numDays] =
            FormControl<String>(validators: [optionalNumber]);
        controls[EventsTable.sireRegistrationName] = FormControl<String>();

        children.addAll([
          ReactiveCheckboxListTile(
            formControlName: EventsTable.pregnancy_inFoal,
            title: const Text('In foal?'),
          ),
          ReactiveTextField(
            formControlName: EventsTable.pregnancy_numDays,
            decoration: const InputDecoration(
              labelText: 'Days since conception',
            ),
            validationMessages: (control) => {
              ValidationMessage.required: 'Please enter a number',
              ValidationMessage.number: 'Please enter a number',
            },
          ),
          ReactiveTextField(
            formControlName: EventsTable.sireRegistrationName,
            decoration: const InputDecoration(
              labelText: 'Sire Registration Name',
            ),
          ),
        ]);
        break;
    }
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

  Future<void> _createEvent() async {
    if (_horses.isNotEmpty) {
      List<Event> events = _horses
          .map((h) => createEventFromMap(form.value, h, eventType: _type))
          .toList();
      await Future.wait(events.map((e) => DB.createEvent(e)));

      if (_type == EventType.foaling) {
        for (var h in _horses) {
          h.setHeatDateFromPregnancy(DateTime.now());
          await DB.updateHorse(h);
        }
      }
    }
    Navigator.pop(context);
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
            title: Text(_index == 0 ? 'Event Type' : formatStr(_type)),
            content:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  child: Text('Select the event type'),
                  padding: EdgeInsets.only(bottom: 8.0)),
              ...EventType.order
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
                        title: Text(formatStr(e)),
                        onTap: () {
                          setState(() {
                            _type = e;
                            _constructForm(_type);
                            _index += 1;
                          });
                        },
                      ),
                    ),
                  )
                  .toList()
            ]),
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
                          Padding(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_eventCanOnlyHaveOneHorse.contains(_type)
                                      ? 'Select a horse for the event'
                                      : 'Select relevant horses'),
                                  _eventCanOnlyHaveOneHorse.contains(_type)
                                      ? const SizedBox.shrink()
                                      : Checkbox(
                                          value: _selectAllHorses,
                                          onChanged: (v) {
                                            setState(() {
                                              _selectAllHorses = v!;
                                              if (_selectAllHorses) {
                                                _horses.addAll(_allHorses);
                                              } else {
                                                _horses.clear();
                                              }
                                            });
                                          },
                                        )
                                ]),
                            padding: const EdgeInsets.only(bottom: 8.0),
                          ),
                          ..._allHorses
                              .where((h) {
                                return _type == EventType.foaling ||
                                        _type == EventType.pregnancyScans
                                    ? h.sex == Sex.female
                                    : true;
                              })
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
                                  child: CheckboxListTile(
                                    value: _horses.any((h) =>
                                        h.registrationName ==
                                        e.registrationName),
                                    title: Text(e.name),
                                    onChanged: (bool? checked) {
                                      setState(() {
                                        if (checked == true &&
                                            _eventCanOnlyHaveOneHorse
                                                .contains(_type)) {
                                          _horses.clear();
                                        }
                                        if (checked == true) {
                                          _horses.add(e);
                                        } else {
                                          _horses.removeWhere((h) =>
                                              h.registrationName ==
                                              e.registrationName);
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
