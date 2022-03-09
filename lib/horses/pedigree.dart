import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:horse_app/horses/list.dart';
import 'package:horse_app/horses/list_item.dart';
import 'package:horse_app/horses/select_from_list.dart';
import 'package:horse_app/horses/single.dart';
import 'package:horse_app/utils/labelled_divider.dart';
import 'package:horse_app/utils/utils.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';

import "../state/db.dart";

// Widget for adding a new horse
class HorsePedigreePage extends StatefulWidget {
  final Horse horse;

  const HorsePedigreePage({Key? key, required this.horse}) : super(key: key);

  @override
  State<HorsePedigreePage> createState() => _HorsePedigreePage();
}

class _HorsePedigreePage extends State<HorsePedigreePage> {
  late Horse horse;

  @override
  initState() {
    super.initState();
    horse = widget.horse;
  }

  Future<Horse?> _tryGetHorse(String? registrationName) async {
    if (registrationName == null) return null;
    try {
      return await db.getHorse(registrationName);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, horse);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${horse.displayName} Pedigree'),
        ),
        body: Column(children: [
          const LabelledDivider('Sire', left: 16),
          ParentSection(
            horse: horse,
            repr: "Sire",
            parentSex: const [Sex.stallion, Sex.gelding],
            future: _tryGetHorse(horse.sireRegistrationName),
            onUpdate: (newSire) {
              setState(() {
                horse = horse.copyWith(
                  sireRegistrationName: newSire != null
                      ? drift.Value(newSire.registrationName)
                      : const drift.Value(null),
                );
                handle(context, db.updateHorse(horse));
              });
            },
          ),
          const LabelledDivider('Dam', left: 16),
          ParentSection(
            horse: horse,
            repr: "Dam",
            parentSex: const [Sex.mare],
            future: _tryGetHorse(horse.damRegistrationName),
            onUpdate: (newDam) {
              setState(() {
                horse = horse.copyWith(
                  damRegistrationName: newDam != null
                      ? drift.Value(newDam.registrationName)
                      : const drift.Value(null),
                );
                handle(context, db.updateHorse(horse));
              });
            },
          ),
          FutureBuilder<List<Horse>>(
            future: db.getHorseOffspring(horse.registrationName),
            builder: (context, snapshot) {
              Widget inColumn(Widget w) {
                return Column(
                  children: [
                    const LabelledDivider('Offspring', left: 16),
                    const SizedBox(height: 10),
                    w
                  ],
                );
              }

              // handle loading states
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return inColumn(const CircularProgressIndicator());

                default:
                  if (snapshot.hasError) {
                    return inColumn(Text(
                      "Failed to load offspring!",
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    ));
                  }
              }

              var offspring = snapshot.data!;

              if (offspring.isEmpty) {
                return inColumn(const Text("No offspring found"));
              }

              return Column(
                children: [
                  LabelledDivider('Offspring (${offspring.length})', left: 16),
                  for (var horse in offspring)
                    HorseListItem(
                      horse: horse,
                      onTap: (horse) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HorseProfilePage(horse: horse),
                            ));
                      },
                    )
                ],
              );
            },
          )
        ]),
      ),
    );
  }
}

class ParentSection extends StatelessWidget {
  final String repr;
  final Future<Horse?> future;
  final Horse horse;
  final List<Sex> parentSex;
  final Function(Horse?) onUpdate;

  const ParentSection(
      {Key? key,
      required this.repr,
      required this.future,
      required this.horse,
      required this.onUpdate,
      required this.parentSex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Horse?>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text(
                "Failed to load ${repr.toLowerCase()}!",
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              );
            }

            if (snapshot.data == null) {
              return ListTile(
                title: Text("$repr not available"),
                subtitle: const Text("Tap to add"),
                trailing: const Icon(Icons.add),
                onTap: () async {
                  var next = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectFromList(
                          before: horse.dateOfBirth, sex: parentSex),
                    ),
                  );
                  if (next != null && next is Horse) onUpdate(next);
                },
              );
            }

            return HorseListItem(
              horse: snapshot.data!,
              onTap: (horse) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HorseProfilePage(horse: horse),
                    ));
              },
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) async {
                  if (value == 'Delete') {
                    onUpdate(null);
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
            );
        }
      },
    );
  }
}
