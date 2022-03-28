import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:horse_app/utils/height_unit.dart';
import 'package:horse_app/utils/labelled_divider.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_range_slider/reactive_range_slider.dart';
import 'package:uuid/uuid.dart';
import '../reactive/image_picker.dart';

import '../utils/utils.dart';
import "../state/db.dart";

// Widget for adding a new horse
class CreateHorsePage extends StatefulWidget {
  final Horse? horse;

  const CreateHorsePage({Key? key, this.horse}) : super(key: key);

  @override
  State<CreateHorsePage> createState() => _CreateHorsePageState();
}

class _CreateHorsePageState extends State<CreateHorsePage> {
  Horse? horse;

  late final FormGroup form;

  @override
  initState() {
    super.initState();
    horse = widget.horse;

    form = FormGroup({
      'registrationName': FormControl<String>(value: horse?.registrationName),
      'registrationNumber':
          FormControl<String>(value: horse?.registrationNumber),
      'name': FormControl<String>(
          validators: [Validators.required], value: horse?.name),
      'dateOfBirth': FormControl<DateTime>(
          validators: [Validators.required], value: horse?.dateOfBirth),
      'sex': FormControl<Sex>(value: horse?.sex ?? Sex.mare),
      'height': FormControl<double>(validators: [], value: horse?.height),
      'weight': FormControl<RangeValues>(
          value: RangeValues(horse?.minWeight ?? 0, horse?.maxWeight ?? 0))
    });
  }

  static const _padding = EdgeInsets.only(top: 20.0);

  @override
  Widget build(BuildContext context) {
    String title =
        horse == null ? 'New Horse' : '${horse!.displayName} Profile';

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, horse);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        bottomNavigationBar: ReactiveForm(
          formGroup: form,
          child: CreateHorseSubmitButton(
            formGroup: form,
            id: horse?.id,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0),
          child: ReactiveForm(
            formGroup: form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: _padding,
                    child: ReactiveTextField(
                      formControlName: 'registrationName',
                      decoration: const InputDecoration(
                        labelText: 'Registration Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: ReactiveTextField(
                      formControlName: 'registrationNumber',
                      decoration: const InputDecoration(
                        labelText: 'Registration Number',
                        hintText: "Enter Registration Number",
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: ReactiveTextField(
                      formControlName: 'name',
                      decoration: const InputDecoration(
                        labelText: 'Paddock Name',
                      ),
                    ),
                  ),

                  //
                  //

                  Padding(
                    padding: _padding,
                    child: ReactiveDateTimePicker(
                      lastDate: DateTime.now(),
                      formControlName: 'dateOfBirth',
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        helperText: '',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  ReactiveDropdownField(
                    formControlName: 'sex',
                    items: Sex.values
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e.toSexString())))
                        .toList(),
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Sex',
                      helperText: '',
                    ),
                  ),

                  const ReactiveHeightField(formControlName: "height"),

                  Padding(
                    padding: _padding,
                    child: ReactiveRangeSlider(
                      decoration: const InputDecoration(
                        labelText: 'Weight Estimate',
                        isDense: true,
                      ),
                      min: 0,
                      max: 1000,
                      labels: const RangeLabels("Min Weight", "Max Weight"),
                      labelBuilder: (v) => RangeLabels(
                        '${v.start.toStringAsFixed(0)} kg',
                        '${v.end.toStringAsFixed(0)} kg',
                      ),
                      divisions: 10,
                      formControlName: "weight",
                    ),
                  ),

                  const SizedBox(height: 48.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateHorseSubmitButton extends StatelessWidget {
  final FormGroup formGroup;
  final String? id;
  const CreateHorseSubmitButton({
    Key? key,
    required this.formGroup,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context);
    if (form == null) {
      return const SizedBox();
    }
    if (form.pristine) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 24.0),
      child: ElevatedButton(
        onPressed: form.valid
            ? () async {
                try {
                  var f = form.value;
                  if (f == null || f is! Map<String, dynamic>) {
                    throw Exception('No values supplied');
                  }

                  final weight = f["weight"] as RangeValues;

                  var horse = Horse(
                    id: id ?? const Uuid().v4(),
                    registrationName: f['registrationName'],
                    registrationNumber: f['registrationNumber'],
                    name: f['name'],
                    dateOfBirth: f['dateOfBirth'],
                    height: f['height'],
                    sex: f['sex'],
                    minWeight: weight.start,
                    maxWeight: weight.end,
                  );

                  await (id != null
                      ? db.updateHorse(horse)
                      : db.createHorse(horse));

                  showSuccess(context,
                      'Sucessfully ${id != null ? 'updated' : 'created'}!');
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context, horse);
                  });
                } catch (e) {
                  showError(context,
                      'Failed to ${id != null ? 'save changes' : 'create'} horse: ${e.toString()}');
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(id != null ? 'Save Changes' : 'Create Horse'),
        ),
      ),
    );
  }
}
