import 'package:flutter/material.dart';
import 'package:horse_app/events/types/noop.dart';
import 'package:horse_app/events/types/drench.dart';
import 'package:horse_app/events/types/foaling.dart';
import 'package:horse_app/events/types/mite_treatment.dart';
import 'package:horse_app/events/types/pregnancy.dart';
import 'package:horse_app/state/db.dart';
import 'package:horse_app/utils/utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

// This represents both the primary public interface and the abstract type for interacting with all
// of the known event types.
abstract class ET {
  // event getters

  static ET get drench => DrenchEvent();
  static ET get miteTreatment => MiteTreatmentEvent();

  static ET get pregnancyScans => PregnancyEvent();
  static ET get foaling => FoalingEvent();

  // all special event types
  static List<ET> types = [
    drench,
    miteTreatment,
    //
    pregnancyScans,
    foaling,
  ];

  static List<String> typeNames = types.map((e) => e.type).toList();
  static List<String> typeFormatted = typeNames.map(formatStr).toList();

// #####################
  // Event interface
// #####################

// type of the event, arbitrary string
  String get type;
  String get formattedType => formatStr(type);

  // the reactive forms fields for the event
  Map<String, AbstractControl<dynamic>> fields(
      Map<String, dynamic>? defaultVals);

  // the corresponding widgets for the above fields, tightly coupled
  // with the above fields
  List<Widget> formFields();

  // if this is true, an event can be made for many horses at once
  // if false, it can only be made for one horse at a time
  bool get canApplyToMany => true;

  bool get onlyAppliesToOne => !canApplyToMany;

  // optional filter than can be overridden, allows the interface
  // to only display some events
  bool appliesTo(Horse h) {
    return true;
  }

  // optional callback for when the event it created, allows custom actions to occur
  void onCreate(Horse h) {}
}
