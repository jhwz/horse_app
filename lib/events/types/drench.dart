import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import './types.dart';

class DrenchEvent extends ET {
  static String drenchType = 'type';

  @override
  String get type => "drench";

  @override
  Map<String, AbstractControl<dynamic>> fields(
      Map<String, dynamic>? defaultVals) {
    return {
      drenchType:
          FormControl(value: defaultVals?[drenchType] ?? '', validators: [
        Validators.required,
      ]),
    };
  }

  @override
  List<Widget> formFields() {
    return [
      ReactiveTextField(
        formControlName: drenchType,
        decoration: const InputDecoration(
          labelText: 'Drench Type',
        ),
      )
    ];
  }
}
