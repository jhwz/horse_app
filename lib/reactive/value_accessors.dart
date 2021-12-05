import 'package:reactive_forms/reactive_forms.dart';

class DoubleValueAccessor extends ControlValueAccessor<double, String> {
  final int fractionDigits;

  DoubleValueAccessor({
    this.fractionDigits = 2,
  });

  @override
  String modelToViewValue(double? modelValue) {
    return modelValue == null ? '' : modelValue.toStringAsFixed(fractionDigits);
  }

  @override
  double? viewToModelValue(String? viewValue) {
    return (viewValue == '' || viewValue == null)
        ? null
        : double.tryParse(viewValue);
  }
}
