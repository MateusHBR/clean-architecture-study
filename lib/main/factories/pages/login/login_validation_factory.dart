import '../../../../presentation/protocols/protocols.dart';

import '../../../../validation/protocols/protocols.dart';
import '../../../composites/composites.dart';

import '../../../builders/builders.dart';

Validation makeLoginValidation() {
  return ValidationComposite(
    validations: makeLoginFieldsValidations(),
  );
}

List<FieldValidation> makeLoginFieldsValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build(),
  ];
}
