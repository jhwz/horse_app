import 'package:flutter/material.dart';
import 'package:horse_app/state/db.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'types.dart';
import '../../reactive/validators.dart';

class PregnancyEvent extends ET {
  static String inFoal = "inFoal";
  static String numDays = "numDays";
  static String sireRegistrationName = "sireRegistrationName";

  @override
  String get type => "pregnancy";

  @override
  bool get canApplyToMany => false;

  @override
  bool appliesTo(Horse h) {
    return h.sex == Sex.mare;
  }

  @override
  Map<String, AbstractControl<dynamic>> fields(
      Map<String, dynamic>? defaultVals) {
    return {
      inFoal: FormControl<bool>(),
      numDays:
          FormControl<String>(validators: [CustomValidators.optionalNumber]),
      sireRegistrationName: FormControl<String>(),
    };
  }

  @override
  List<Widget> formFields() {
    return [
      ReactiveCheckboxListTile(
        formControlName: inFoal,
        title: const Text('In foal?'),
      ),
      ReactiveTextField(
        formControlName: numDays,
        decoration: const InputDecoration(
          labelText: 'Days since conception',
        ),
        validationMessages: (control) => {
          ValidationMessage.required: 'Please enter a number',
          ValidationMessage.number: 'Please enter a number',
        },
      ),
      ReactiveTextField(
        formControlName: sireRegistrationName,
        decoration: const InputDecoration(
          labelText: 'Sire Registration Name',
        ),
      ),
    ];
  }
}
