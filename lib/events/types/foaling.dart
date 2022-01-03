import 'package:flutter/material.dart';
import 'package:horse_app/state/db.dart';
import 'package:reactive_forms/reactive_forms.dart';

import './types.dart';

class FoalingEvent extends ET {
  static String foalColour = 'foalColour';
  static String foalSex = 'foalSex';
  static String sireRegistrationName = 'sireRegistrationName';

  @override
  String get type => "foaling";

  @override
  bool get canApplyToMany => false;

  @override
  bool appliesTo(Horse h) {
    return h.sex == Sex.female;
  }

  @override
  void onCreate(Horse h) async {
    var updated = h.updateHeatFromFoalingDate(DateTime.now());
    await db.updateHorse(updated);
  }

  @override
  Map<String, AbstractControl<dynamic>> fields(
      Map<String, dynamic>? defaultVals) {
    return {
      foalColour: FormControl<String>(
        value: defaultVals?[foalColour] ?? '',
      ),
      sireRegistrationName: FormControl<String>(
          value: defaultVals?[sireRegistrationName] ?? '',
          validators: [Validators.required]),
      foalSex: FormControl<int>(
          value: defaultVals?[foalSex] ?? Sex.female.index,
          validators: [Validators.required]),
    };
  }

  @override
  List<Widget> formFields() {
    return [
      ReactiveTextField(
        formControlName: foalColour,
        decoration: const InputDecoration(
          labelText: 'Foal Colour',
        ),
      ),
      ReactiveTextField(
        formControlName: sireRegistrationName,
        decoration: const InputDecoration(
          labelText: 'Sire Registration Name',
        ),
        validationMessages: (c) => {
          ValidationMessage.required: "Require sire registration name",
        },
      ),
      ReactiveDropdownField(
        formControlName: foalSex,
        items: [
          DropdownMenuItem(
            value: Sex.female.index,
            child: const Text('Female'),
          ),
          DropdownMenuItem(
            value: Sex.male.index,
            child: const Text('Male'),
          ),
        ],
        decoration: const InputDecoration(
          labelText: 'Sex',
        ),
        validationMessages: (c) => {
          ValidationMessage.required: "Require foal sex",
        },
      ),
    ];
  }
}
