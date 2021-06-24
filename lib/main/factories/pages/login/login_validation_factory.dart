import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(
    validations: [
      RequiredFieldValidation('email'),
      EmailFieldValidation('email'),
      RequiredFieldValidation('password'),
    ],
  );
}
