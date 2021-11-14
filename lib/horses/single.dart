import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:horse_app/horses/heat.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import '../utils/reactive_image_picker.dart';

import '../utils/utils.dart';
import "../state/db.dart";

// Widget for adding a new horse
class HorseProfilePage extends StatefulWidget {
  final Horse? horse;

  const HorseProfilePage({Key? key, this.horse}) : super(key: key);

  @override
  State<HorseProfilePage> createState() => _HorseProfilePageState();
}

class _HorseProfilePageState extends State<HorseProfilePage> {
  static const String __validHands = 'validHands';

  Horse? horse;

  static Map<String, dynamic>? _validHands(AbstractControl<dynamic> control) {
    try {
      String hands = control.value is String ? control.value : '';
      if (!hands.contains(".")) {
        return {__validHands: true};
      }
      var parts = hands.split(".");
      if (parts.length != 2) {
        return {__validHands: true};
      }
      var val = int.parse(parts[0]);
      if (val < 0 || val > 30) {
        return {__validHands: true};
      }
      val = int.parse(parts[1]);
      if (val < 0 || val > 3) {
        return {__validHands: true};
      }
    } catch (e) {
      return {__validHands: true};
    }
    return null;
  }

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
      'sireRegistrationName':
          FormControl<String>(value: horse?.sireRegistrationName),
      'damRegistrationName':
          FormControl<String>(value: horse?.damRegistrationName),
      'name': FormControl<String>(
          validators: [Validators.required], value: horse?.name),
      'dateOfBirth': FormControl<DateTime>(
          validators: [Validators.required], value: horse?.dateOfBirth),
      'sex': FormControl<Sex>(value: horse?.sex ?? Sex.female),
      'height': FormControl<String>(
          validators: [_validHands], value: horse?.height.toString()),
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = horse == null ? 'New Horse' : '${horse!.name} Profile';

    return Scaffold(
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
                horse == null || horse!.sex != Sex.female
                    ? null
                    : ListTile(
                        trailing:
                            const Icon(Icons.keyboard_arrow_right_outlined),
                        subtitle: const Text('View heat cycle overview'),
                        title: horse!.heat == null
                            ? const Text('No dates set yet!')
                            : horse!.isInHeat()
                                ? const Text('In Heat')
                                : const Text('Not in Heat'),
                        onTap: () async {
                          var next = await Navigator.push<Horse>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HorseHeatPage(horse: horse!)));

                          setState(() {
                            horse =
                                horse!.copyWith(heat: drift.Value(next?.heat));
                          });
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                Row(
                  children: <Widget>[
                    Text(
                      "Details",
                      style: Theme.of(context).textTheme.overline,
                    ),
                    const Expanded(
                        child: Divider(
                      indent: 10,
                    )),
                  ],
                ),
                ReactiveTextField(
                  readOnly: horse != null,
                  formControlName: 'registrationName',
                  decoration: const InputDecoration(
                    labelText: 'Registration Name',
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'sireRegistrationName',
                  decoration: const InputDecoration(
                    labelText: 'Registration Number',
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'damRegistrationName',
                  decoration: const InputDecoration(
                    labelText: 'Sire Registration Number',
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'registrationNumber',
                  decoration: const InputDecoration(
                    labelText: 'Dam Registration Number',
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Paddock Name',
                  ),
                ),
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
                    DropdownMenuItem(value: Sex.female, child: Text('Female')),
                    DropdownMenuItem(value: Sex.male, child: Text('Male')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Sex',
                    helperText: '',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: ReactiveTextField(
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
                  if (update) {
                    await DB.updateHorse(Horse.fromData(formGroup.value));
                  } else {
                    await DB.createHorse(Horse.fromData(formGroup.value));
                  }
                  showSuccess(context,
                      'Sucessfully ${update ? 'updated' : 'created'}!');
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context);
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
