import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({
    required this.validations,
  });

  @override
  String? validate({required String field, required String? value}) {
    String? error;

    for (final validation in validations.where(
      (validator) => validator.field == field,
    )) {
      print(validations.length);
      error = validation.validate(value);
      print(error);
      if (error?.isNotEmpty ?? false) {
        return error;
      }
    }

    return error;
  }
}
