import 'package:reactive_forms/reactive_forms.dart';

/// Provides a set of built-in validators that can be used by form controls.
class CustomValidators {
  /// Gets a validator that requires the control have a non-empty value.
  static ValidatorFunction get optionalNumber =>
      OptionalNumberValidator().validate;
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
