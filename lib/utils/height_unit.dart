// only add new units at the bottom of the enum
// the enum is serialised with the enum index
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/preferences.dart';
import 'package:horse_app/theme.dart';
import 'package:reactive_forms/reactive_forms.dart';

final heightUnitProvider =
    StateNotifierProvider<PreferencesNotifier<HeightUnit>, HeightUnit>(
  (ref) => PreferencesNotifier(
    "heightUnit",
    ref,
    (prefs, key) => HeightUnit.values[prefs.getInt(key) ?? 0],
    (prefs, key, value) => prefs.setInt(key, value.index),
    HeightUnit.hands,
  ),
);

enum HeightUnit {
  hands,
  millimeters,
  centimeters,
  metres,
}

extension HeightUnitMethods on HeightUnit {
  static const Map<HeightUnit, String> _short = {
    HeightUnit.hands: 'hh',
    HeightUnit.millimeters: 'mm',
    HeightUnit.centimeters: 'cm',
    HeightUnit.metres: 'm',
  };
  String get short => _short[this] ?? '';

  static const Map<HeightUnit, String> _repr = {
    HeightUnit.hands: 'Hands',
    HeightUnit.millimeters: 'Millimeters',
    HeightUnit.centimeters: 'Centimeters',
    HeightUnit.metres: 'Metres',
  };

  String get repr => _repr[this] ?? 'Unknown';
}

class HeightUnitDialog extends ConsumerWidget {
  const HeightUnitDialog({Key? key}) : super(key: key);

  _updatePreference(BuildContext context, WidgetRef ref, HeightUnit unit) {
    ref.read(heightUnitProvider.notifier).state = unit;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(heightUnitProvider);

    return SimpleDialog(
      title: const Text('Select Unit'),
      children: HeightUnit.values
          .map<Widget>(
            (HeightUnit unit) => RadioListTile<HeightUnit>(
              value: unit,
              groupValue: current,
              onChanged: (_) => _updatePreference(context, ref, unit),
              title: Text("${unit.repr} (${unit.short})"),
            ),
          )
          .toList(),
    );
  }
}

class ReactiveHeightField extends ConsumerWidget {
  final String formControlName;
  const ReactiveHeightField({
    Key? key,
    required this.formControlName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = ref.watch(heightUnitProvider);

    return ReactiveTextField(
      key: ValueKey(height),
      valueAccessor: HeightValueAccessor(height),
      formControlName: formControlName,
      keyboardType:
          const TextInputType.numberWithOptions(signed: false, decimal: true),
      decoration: InputDecoration(
        labelText: 'Height',
        suffixIcon: TextButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) => const HeightUnitDialog(),
            );
          },
          child: Text(height.short),
        ),
      ),
      validationMessages: (c) =>
          {ValidationMessage.number: "Invalid ${height.repr} format"},
    );
  }
}

class HeightValueAccessor extends ControlValueAccessor<double, String> {
  final HeightUnit unit;

  HeightValueAccessor(this.unit);

  @override
  String modelToViewValue(double? modelValue) {
    if (modelValue == null) return '';

    switch (unit) {
      case HeightUnit.hands:
        final hands = (modelValue / 101.60).floor();
        final inches = ((modelValue % 101.60) / 25.4).round();
        return '$hands.$inches';

      case HeightUnit.millimeters:
        return (modelValue).toStringAsFixed(0);

      case HeightUnit.centimeters:
        return (modelValue / 10.0).toStringAsFixed(0);

      case HeightUnit.metres:
        return (modelValue / 1000.0).toStringAsFixed(2);
    }
  }

  @override
  double? viewToModelValue(String? viewValue) {
    if (viewValue == null) return null;
    final val = double.tryParse(viewValue);
    if (val == null) return null;

    switch (unit) {
      case HeightUnit.hands:
        final parts = viewValue.split('.');
        final hands = int.tryParse(parts[0]) ?? 0;
        final inches = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        return hands.toDouble() * 101.60 + inches.toDouble() * 25.4;

      case HeightUnit.millimeters:
        return val;

      case HeightUnit.centimeters:
        return val * 10.0;

      case HeightUnit.metres:
        return val * 1000.0;
    }
  }
}
