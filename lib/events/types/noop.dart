import 'package:flutter/material.dart';
import 'package:horse_app/events/types/types.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NoopEvent extends ET {
  final String _type;

  NoopEvent(this._type);

  @override
  Map<String, AbstractControl<dynamic>> fields(
      Map<String, dynamic>? defaultVals) {
    return {};
  }

  @override
  List<Widget> formFields() {
    return [];
  }

  @override
  String get type => _type;
}
