import 'package:reactive_forms/reactive_forms.dart';

/// Provides a set of built-in validators that can be used by form controls.
class CustomValidators {
  /// Gets a validator that requires the control have a non-empty value.
  static ValidatorFunction get optionalNumber =>
      OptionalNumberValidator().validate;

  static ValidatorFunction get hands => HandsNumberValidator().validate;
}

/// Validator that requires the control's value pass an email validation test.
class OptionalNumberValidator extends Validator<dynamic> {
  static final RegExp numberRegex = RegExp(r'^-?[0-9]+$');

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    return (control.value != null) &&
            !numberRegex.hasMatch(control.value.toString())
        ? <String, dynamic>{ValidationMessage.number: true}
        : null;
  }
}

class HandsNumberValidator extends Validator<dynamic> {
  static final RegExp numberRegex = RegExp(r'^-?[0-9]+$');

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    try {
      if (control.value is double) {
        if (control.value < 0 || control.value > 30) {
          return <String, dynamic>{ValidationMessage.number: true};
        }
        return null;
      }

      String hands = control.value is String ? control.value : '';
      if (!hands.contains(".")) {
        return {ValidationMessage.number: true};
      }
      var parts = hands.split(".");
      if (parts.length != 2) {
        return {ValidationMessage.number: true};
      }
      var val = int.parse(parts[0]);
      if (val < 0 || val > 30) {
        return {ValidationMessage.number: true};
      }
      val = int.parse(parts[1]);
      if (val < 0 || val > 3) {
        return {ValidationMessage.number: true};
      }
    } catch (e) {
      return {ValidationMessage.number: true};
    }
    return null;
  }
}
