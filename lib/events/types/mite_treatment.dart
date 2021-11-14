import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import './types.dart';

class MiteTreatmentEvent extends ET {
  static String miteTreatmentType = 'type';

  @override
  String get type => "miteTreatment";

  @override
  FormGroup fields(Map<String, dynamic>? defaultVals) {
    return FormGroup({
      miteTreatmentType: FormControl(
        value: defaultVals?[miteTreatmentType] ?? '',
        validators: [Validators.required],
      ),
    });
  }

  @override
  List<Widget> formFields() {
    return [
      ReactiveTextField(
        formControlName: miteTreatmentType,
        decoration: const InputDecoration(
          labelText: 'Treatment Type',
        ),
      )
    ];
  }
}
