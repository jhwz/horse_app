import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:horse_app/horses/create.dart';
import 'package:horse_app/horses/heat.dart';
import 'package:horse_app/horses/notes.dart';
import 'package:horse_app/horses/pedigree.dart';
import 'package:horse_app/utils/utils.dart';

import "../state/db.dart";

// Widget for adding a new horse
class HorseProfilePage extends StatefulWidget {
  final Horse horse;

  const HorseProfilePage({Key? key, required this.horse}) : super(key: key);

  @override
  State<HorseProfilePage> createState() => _HorseProfilePageState();
}

class _HorseProfilePageState extends State<HorseProfilePage> {
  late Horse horse;
  @override
  initState() {
    horse = widget.horse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = horse.displayName;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) async {
              if (value == 'Delete') {
                try {
                  await db.deleteHorse(horse.registrationName);
                  showSuccess(context, 'Deleted');
                  Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('General Information'),
                subtitle: const Text('Identification, sex, DOB and more'),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: () async {
                  var next = await Navigator.push<Horse>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateHorsePage(horse: horse),
                    ),
                  );
                  setState(() {
                    horse = next!;
                  });
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.note_alt_outlined),
                title: const Text('Notes'),
                subtitle: Text('General notes about ${horse.displayName}'),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: () async {
                  var newNotes = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNotePage(
                        note: horse.notes ?? "",
                      ),
                    ),
                  );
                  if (newNotes != null && newNotes is String) {
                    setState(() {
                      horse = horse.copyWith(notes: drift.Value(newNotes));
                      db.updateHorse(horse);
                    });
                  }
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_tree_outlined),
                title: const Text('Pedigree'),
                subtitle: const Text('View sire, dam and offspring'),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: () async {
                  var next = await Navigator.push<Horse>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HorsePedigreePage(horse: horse),
                    ),
                  );
                  if (next != null && next is Horse) {
                    setState(() {
                      horse = next;
                    });
                  }
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              if (horse.sex == Sex.mare)
                ListTile(
                  leading: const Icon(Icons.change_circle_outlined),
                  title: const Text('Heat cycle'),
                  subtitle: horse.heatCycleStart == null
                      ? const Text('No dates set yet!')
                      : horse.isInHeat()
                          ? const Text('In Heat')
                          : const Text('Not in Heat'),
                  trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  onTap: () async {
                    var next = await Navigator.push<Horse?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HorseHeatPage(horse: horse),
                      ),
                    );

                    if (next != null && next is Horse) {
                      setState(() {
                        horse = horse.copyWith(
                            heatCycleStart: drift.Value(next.heatCycleStart));
                      });
                    }
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
