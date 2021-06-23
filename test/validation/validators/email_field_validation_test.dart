import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/validation/validators/validators.dart';

void main() {
  late EmailFieldValidation sut;

  setUp(() {
    sut = EmailFieldValidation('email');
  });

  test('should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });

  test('should return null if email is valid', () {
    final error = sut.validate(faker.internet.email());

    expect(error, null);
  });

  test('should return error if email is invalid', () {
    final error = sut.validate(faker.internet.domainName());

    expect(error, 'Email inválido.');
  });
}
