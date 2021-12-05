import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:horse_app/horses/heat.dart';
import 'package:horse_app/reactive/validators.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
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
  static const String __validHands = 'validHands';

  Horse? horse;

  late final FormGroup form;

  @override
  initState() {
    super.initState();
    horse = widget.horse;

    form = FormGroup({
      'photo': FormControl<Uint8List>(value: horse?.photo),
      'registrationName': FormControl<String>(
          validators: [Validators.required], value: horse?.registrationName),
      'registrationNumber':
          FormControl<String>(value: horse?.registrationNumber),
      'name': FormControl<String>(
          validators: [Validators.required], value: horse?.name),
      'dateOfBirth': FormControl<DateTime>(
          validators: [Validators.required], value: horse?.dateOfBirth),
      'sex': FormControl<Sex>(value: horse?.sex ?? Sex.female),
      'height': FormControl<double>(
          validators: [CustomValidators.hands], value: horse?.height),
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = horse == null ? 'New Horse' : '${horse!.name} Profile';

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
            update: horse != null,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ReactiveForm(
            formGroup: form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget?>[
                  ReactiveImagePicker(
                    formControlName: 'photo',
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        helperText: ''),
                    inputBuilder: (onPressed) => TextButton.icon(
                      onPressed: onPressed,
                      icon: const Icon(Icons.add),
                      label: const Text('Set profile photo'),
                    ),
                  ),

                  //
                  //

                  const SectionLabel("Identification"),
                  ReactiveTextField(
                    readOnly: horse != null,
                    formControlName: 'registrationName',
                    decoration: const InputDecoration(
                      labelText: 'Registration Name',
                    ),
                  ),
                  ReactiveTextField(
                    formControlName: 'registrationNumber',
                    decoration: const InputDecoration(
                      labelText: 'Registration Number',
                    ),
                  ),
                  ReactiveTextField(
                    formControlName: 'name',
                    decoration: const InputDecoration(
                      labelText: 'Paddock Name',
                    ),
                  ),

                  //
                  //

                  const SectionLabel("Details"),
                  ReactiveDateTimePicker(
                    formControlName: 'dateOfBirth',
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      helperText: '',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  ReactiveDropdownField(
                    formControlName: 'sex',
                    items: const [
                      DropdownMenuItem(
                          value: Sex.female, child: Text('Female')),
                      DropdownMenuItem(value: Sex.male, child: Text('Male')),
                    ],
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Sex',
                      helperText: '',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: ReactiveTextField(
                      valueAccessor: DoubleValueAccessor(),
                      formControlName: 'height',
                      decoration: const InputDecoration(
                          labelText: 'Height',
                          helperText: 'Height in hands (hh)',
                          suffixText: 'hh'),
                      validationMessages: (c) =>
                          {__validHands: "Invalid hands format; try '15.3'"},
                    ),
                  ),
                ]
                    .where((e) => e != null)
                    .toList()
                    .map<Widget>((w) => Padding(
                        padding: const EdgeInsets.only(top: 12), child: w))
                    .toList(),
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
  final bool update;
  const CreateHorseSubmitButton({
    Key? key,
    required this.formGroup,
    required this.update,
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

                  var horse = Horse(
                    photo: f['photo'],
                    registrationName: f['registrationName'],
                    damRegistrationName: f['damRegistrationName'],
                    sireRegistrationName: f['sireRegistrationName'],
                    registrationNumber: f['registrationNumber'],
                    name: f['name'],
                    dateOfBirth: f['dateOfBirth'],
                    height: f['height'],
                    sex: f['sex'],
                  );

                  await (update
                      ? DB.updateHorse(horse)
                      : DB.createHorse(horse));

                  showSuccess(context,
                      'Sucessfully ${update ? 'updated' : 'created'}!');
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context, horse);
                  });
                } catch (e) {
                  showError(context,
                      'Failed to ${update ? 'save changes' : 'create'} horse: ${e.toString()}');
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(update ? 'Save Changes' : 'Create Horse'),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.overline,
          ),
          const Expanded(
              child: Divider(
            indent: 10,
          )),
        ],
      ),
    );
  }
}
