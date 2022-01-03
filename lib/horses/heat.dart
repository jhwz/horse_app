import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';

import "../state/db.dart";
import "../utils/utils.dart";

// Widget for adding a new horse
class HorseHeatPage extends StatefulWidget {
  final Horse horse;

  const HorseHeatPage({Key? key, required this.horse}) : super(key: key);

  @override
  State<HorseHeatPage> createState() => _HorseHeatPage();
}

class _HorseHeatPage extends State<HorseHeatPage> {
  late final FormGroup form;
  late Horse horse;

  String? updateErr;

  @override
  initState() {
    super.initState();
    horse = widget.horse;

    form = FormGroup({
      'heatCycleStart': FormControl<DateTime>(value: horse.nextHeatStart()),
    });

    form.valueChanges.listen((event) async {
      if (event == null) {
        return;
      }
      var raw = event['heatCycleStart'];
      horse = horse.copyWith(
          heatCycleStart:
              raw is DateTime ? drift.Value(raw) : const drift.Value.absent());
      try {
        await db.updateHorse(horse);
      } catch (e) {
        setState(() {
          updateErr = 'Failed to update: ${e.toString()}';
        });
      }
      setState(() {
        horse = horse;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final inHeat = horse.isInHeat();

    List<Widget> children = [];
    if (inHeat) {
      children = [
        (Container(
          margin: const EdgeInsets.only(top: 12, bottom: 16),
          child: Text(
            'In heat',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(const TextStyle(color: Colors.white)),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        )),
        (Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text("End of current cycle:",
                        style: Theme.of(context).textTheme.caption)),
                Text(
                    DateTime.now()
                        .difference(horse.currentHeatEnd()!)
                        .abs()
                        .daysRelNow(),
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ))),
      ];
    } else if (horse.heatCycleStart != null) {
      children = [
        (Container(
          margin: const EdgeInsets.only(top: 12, bottom: 16),
          child: Text(
            'Not in heat',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(const TextStyle(color: Colors.white60)),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        )),
      ];
    }
    if (horse.heatCycleStart != null) {
      final nextHeat = DateTime.now().difference(horse.nextHeatStart()!).abs();
      children.add((Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                  child: Text("Next Heat Start:",
                      style: Theme.of(context).textTheme.caption)),
              Text(nextHeat.daysRelNow(),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ))));
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, horse);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${horse.displayName} Heat Cycle'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ReactiveDateTimePicker(
                  formControlName: 'heatCycleStart',
                  firstDate: DateTime.now().subtract(const Duration(days: 337)),
                  decoration: InputDecoration(
                    labelText: 'Start of heat period',
                    errorText: updateErr,
                    errorMaxLines: 5,
                    helperMaxLines: 99,
                    helperText: horse.heatCycleStart == null &&
                            updateErr == null
                        ? 'No heat cycle set yet! Set this date to any time your mare has been or will be in heat and we will handle everything else. When a pregnancy event occurs for the mare, their cycle will automatically be updated.'
                        : null,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              ...children,
            ]),
          ),
        ),
      ),
    );
  }
}
