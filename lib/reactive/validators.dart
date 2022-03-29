import 'package:reactive_forms/reactive_forms.dart';

/// Provides a set of built-in validators that can be used by form controls.
class CustomValidators {
  /// Gets a validator that requires the control have a non-empty value.
  static ValidatorFunction get optionalNumber =>
      OptionalNumberValidator().validate;

  static ValidatorFunction get money => MoneyValidator().validate;
}

/// Validator that requires the control's value pass an email validation test.
class OptionalNumberValidator extends Validator<dynamic> {
  static final RegExp numberRegex = RegExp(r'^-?[0-9]+$');

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    if (control.value == null) {
      return null;
    }
    if (numberRegex.hasMatch(control.value.toString())) {
      return null;
    }
    return <String, dynamic>{ValidationMessage.number: true};
  }
}

class MoneyValidator extends Validator<dynamic> {
  static final RegExp numberRegex = RegExp(r'^([1-9][0-9]*|0)(\.[0-9]{2})?$');

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    if (control.value == null || !numberRegex.hasMatch(control.value)) {
      return <String, dynamic>{ValidationMessage.number: true};
    }
    return null;
  }
}
