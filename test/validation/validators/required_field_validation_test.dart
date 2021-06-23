import 'package:test/test.dart';

import 'package:course_clean_arch/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('anyField');
  });

  test('should return null if value is not empty', () {
    final error = sut.validate('any-value');

    expect(error, null);
  });

  test('should return error string if value is empty', () {
    final error = sut.validate('');

    expect(error, 'Campo obrigatório.');
  });

  test('should return error string if value is null', () {
    final error = sut.validate(null);

    expect(error, 'Campo obrigatório.');
  });
}
