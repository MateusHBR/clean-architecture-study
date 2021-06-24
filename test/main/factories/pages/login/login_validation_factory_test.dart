import 'package:test/test.dart';

import 'package:course_clean_arch/main/factories/factories.dart';
import 'package:course_clean_arch/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () {
    final validations = [
      RequiredFieldValidation('email'),
      EmailFieldValidation('email'),
      RequiredFieldValidation('password'),
    ];

    final loginValidations = makeLoginFieldsValidations();

    expect(loginValidations, validations);
  });
}
