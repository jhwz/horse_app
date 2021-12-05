import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:horse_app/horses/create.dart';
import 'package:horse_app/horses/heat.dart';
import 'package:horse_app/reactive/validators.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import '../reactive/image_picker.dart';

import '../utils/utils.dart';
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
    String title = '${horse.name} Profile';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Details'),
                subtitle: const Text('Identification and general information'),
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
              if (horse.sex == Sex.female)
                ListTile(
                  title: horse.heat == null
                      ? const Text('No dates set yet!')
                      : horse.isInHeat()
                          ? const Text('In Heat')
                          : const Text('Not in Heat'),
                  subtitle: const Text('View heat cycle overview'),
                  trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  onTap: () async {
                    var next = await Navigator.push<Horse>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HorseHeatPage(horse: horse),
                      ),
                    );

                    setState(() {
                      horse = horse.copyWith(heat: drift.Value(next?.heat));
                    });
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
