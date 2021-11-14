import 'package:flutter/material.dart';
import 'package:horse_app/events/types/types.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NoopEvent extends ET {
  final String _type;

  NoopEvent(this._type);

  @override
  FormGroup fields(Map<String, dynamic>? defaultVals) {
    return FormGroup({});
  }

  @override
  List<Widget> formFields() {
    return [];
  }

  @override
  String get type => _type;
}
