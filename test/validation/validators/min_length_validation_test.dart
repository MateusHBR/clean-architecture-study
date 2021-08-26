import 'dart:math';

import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:course_clean_arch/validation/validators/min_length_validation.dart';
import 'package:test/test.dart';

void main() {
  test('should return error if value is empty', () {
    final sut = MinLengthValidation(
      field: 'field',
      size: 5,
    );

    expect(sut.validate(''), R.strings.invalidField);
  });

  test('should return error if value is null', () {
    final sut = MinLengthValidation(
      field: 'field',
      size: 5,
    );

    expect(sut.validate(null), R.strings.invalidField);
  });

  test('should return error if value lenght is less than size', () {
    final sut = MinLengthValidation(
      field: 'field',
      size: 5,
    );

    expect(sut.validate('null'), R.strings.invalidField);
  });
}
