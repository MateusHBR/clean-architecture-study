import '../../../../presentation/protocols/protocols.dart';

import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(
    validations: makeLoginFieldsValidations(),
  );
}

List<FieldValidation> makeLoginFieldsValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailFieldValidation('email'),
    RequiredFieldValidation('password'),
  ];
}
