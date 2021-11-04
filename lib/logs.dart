import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:horse_app/models/horse.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import './_utils.dart';
import "./models/event.dart";
import "./db.dart";

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  static String title = '$appTitle - Logs';

  // handles the search bar at the top
  Widget searchBarOrTitle = Text(title);
  Icon searchIconOrCancel = const Icon(Icons.search);

  // state for infinite loading of the entries
  static const _pageSize = 20;
  String filter = '';

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int _) async {
    try {
      int pageKey = _pagingController.itemList?.fold(
              0,
              (value, e) =>
                  e is List<Event> ? value! + e.length : value! + 1) ??
          0;

      // fetch the horses
      var events = await DB.listEvents(
          filter: filter, offset: pageKey, limit: _pageSize);

      if (events.isEmpty) {
        _pagingController.appendLastPage([]);
        return;
      }

      // collapse similar events
      List<dynamic> out = [];
      List<Event> curr = [];
      for (int i = 0; i < events.length; i++) {
        if (curr.isEmpty) {
          curr.add(events[i]);
          continue;
        }

        if (curr.last.type == events[i].type &&
            curr.last.date.difference(events[i].date).abs().inHours < 8) {
          curr.add(events[i]);
        } else {
          if (curr.length > 1) {
            out.add(curr);
          } else {
            out.add(curr.first);
          }
          curr = [events[i]];
        }
      }
      var isLastPage = events.length < _pageSize;

      if (curr.isNotEmpty) {
        // keep looping through the database until we fill up the final list. Normally
        // this will fetch an additional page and discard most of it so it is a little
        // wasteful but hopefully not noticable!
        while_loop:
        while (!isLastPage) {
          pageKey += _pageSize;
          var eventsNext = await DB.listEvents(
              filter: filter, offset: pageKey, limit: _pageSize);
          isLastPage = eventsNext.length < _pageSize;
          for (int i = 0; i < eventsNext.length; i++) {
            if (curr.last.type == eventsNext[i].type &&
                curr.last.date.difference(eventsNext[i].date).abs().inHours <
                    8) {
              curr.add(eventsNext[i]);
            } else {
              break while_loop;
            }
          }
        }
        if (curr.length > 1) {
          out.add(curr);
        } else {
          out.add(curr.first);
        }
      }

      if (isLastPage) {
        _pagingController.appendLastPage(out);
      } else {
        final nextPageKey = pageKey + out.length;
        _pagingController.appendPage(out, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _onTap(Event e) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LogSummaryPage(event: e);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBarOrTitle,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (searchIconOrCancel.icon == Icons.search) {
                  searchIconOrCancel = const Icon(Icons.cancel);
                  searchBarOrTitle = ListTile(
                    title: TextField(
                      onChanged: (v) {
                        filter = v;
                        _pagingController.refresh();
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Filter...',
                        border: InputBorder.none,
                        fillColor: Theme.of(context).primaryColorLight,
                        filled: true,
                      ),
                    ),
                  );
                } else {
                  searchIconOrCancel = const Icon(Icons.search);
                  searchBarOrTitle = Text(title);
                  filter = '';
                  _pagingController.refresh();
                }
              });
            },
            icon: searchIconOrCancel,
          )
        ],
      ),

      drawer: appDrawer(context, "/logs"),

      body: Center(
        child: PagedListView<int, dynamic>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            itemBuilder: (context, item, index) {
              if (item is List<Event>) {
                return LogListGroup(events: item, onTap: _onTap);
              }
              return LogListItem(event: item, onTap: _onTap);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NewLogPage();
          }));
          _pagingController.refresh();
        },
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class LogListItem extends StatelessWidget {
  final Event event;
  final Function(Event) onTap;

  const LogListItem({Key? key, required this.event, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        formatStr(event.type),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(event.horse.name), Text(event.date.date())]),
      isThreeLine: true,
      onTap: () {
        onTap(event);
      },
    );
  }
}

class LogListGroup extends StatelessWidget {
  final Function(Event) onTap;
  final List<Event> events;

  const LogListGroup({Key? key, required this.events, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: ListTile(
        title: Text(
          formatStr(events[0].type),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${events.length} horses'),
        ]),
        isThreeLine: true,
      ),
      collapsed: const SizedBox.shrink(),
      expanded: Column(
        children:
            events.map((e) => LogListItem(event: e, onTap: onTap)).toList(),
      ),
    );
  }
}

class NewLogPage extends StatefulWidget {
  const NewLogPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewLogPageState();
}

// This is disgusting...
class _NewLogPageState extends State<NewLogPage> {
  static const String _title = '$appTitle - New Log';
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
      EventsTable.notes: FormControl<String>()
    };
    List<Widget> children = [
      ReactiveTextField(
        formControlName: EventsTable.notes,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Event notes (optional)',
        ),
      ),
    ];
    switch (_type) {
      case EventType.drench:
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
                  child: CreateLogSubmitButton(
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

class CreateLogSubmitButton extends StatelessWidget {
  final FormGroup formGroup;
  final Function createEvent;

  const CreateLogSubmitButton({
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

class LogSummaryPage extends StatefulWidget {
  final Event event;

  const LogSummaryPage({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LogSummaryPageState();
}

// This is disgusting...
class _LogSummaryPageState extends State<LogSummaryPage> {
  static const String _title = 'Log Summary';

  List<Widget> _buildEvents(Event e) {
    var out = <Widget>[];

    Widget textWidget(String? text, String value, {bool bold = false}) {
      return TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: text,
          border: InputBorder.none,
        ),
        style:
            TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        readOnly: true,
        focusNode: FocusNode(canRequestFocus: false, skipTraversal: true),
      );
    }

    if (e is DrenchEvent) {
      out.add(textWidget("Drench Type", e.drenchType));
    } else if (e is FarrierEvent) {
      //
    } else if (e is MiteTreatmentEvent) {
      out.add(textWidget("Mite Treatment Type", e.miteTreatmentType));
    } else if (e is DentistEvent) {
      //
    } else if (e is FoalingEvent) {
      out.add(textWidget("Foal Sex", e.foalSex.toSexString()));
      out.add(textWidget("Foal Colour", e.foalColour));
      out.add(textWidget("Foal Sire", e.sireRegistrationName));
    } else if (e is FeedEvent) {
      //
    } else if (e is VetEvent) {
      //
    } else if (e is PregnancyScans) {
      out.add(
          textWidget(null, e.inFoal ? "In Foal" : "Not In Foal", bold: true));
      out.add(textWidget("Days in foal", e.numberOfDays.toString()));

      if (e.inFoal) {
        if (e.numberOfDays != null) {
          var conception = e.date.subtract(Duration(days: e.numberOfDays!));
          var estimateFoaling = conception.add(const Duration(days: 338));

          out.add(textWidget("Estimate Conception", conception.date()));
          out.add(textWidget("Estimate Foaling Date", estimateFoaling.date()));
        }
        out.add(textWidget("Foal Sire", e.sireRegistrationName ?? "N/A"));
      }
    }

    out = out
        .map<Widget>((w) => Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 12),
              child: w,
            ))
        .toList();

    if (out.isNotEmpty) {
      out.insert(
          0,
          Row(
            children: [
              Text(
                "   Event Specific Details",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const Expanded(
                child: Divider(
                  thickness: 1,
                  indent: 6,
                  endIndent: 12,
                ),
              )
            ],
          ));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                formatStr(e.type),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Horse",
                  border: InputBorder.none,
                ),
                controller: TextEditingController(
                  text: e.horse.name,
                ),
                readOnly: true,
                focusNode:
                    FocusNode(canRequestFocus: false, skipTraversal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Time of event",
                  border: InputBorder.none,
                ),
                controller: TextEditingController(text: e.date.dateTime()),
                readOnly: true,
                focusNode:
                    FocusNode(canRequestFocus: false, skipTraversal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 12),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Event notes",
                  border: InputBorder.none,
                ),
                controller: TextEditingController(
                  text: e.notes != "" ? e.notes : "None",
                ),
                readOnly: true,
                maxLines: null,
                focusNode:
                    FocusNode(canRequestFocus: false, skipTraversal: true),
              ),
            ),
            ..._buildEvents(e),
          ],
        ),
      ),
    );
  }
}
