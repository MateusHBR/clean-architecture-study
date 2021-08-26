import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:course_clean_arch/validation/validators/compare_field_validation.dart';
import 'package:test/test.dart';

void main() {
  test('should return error if values are different', () {
    final sut = CompareFieldValidation(
      field: 'any_field',
      valueToCompare: 'wrong value',
    );

    expect(
      sut.validate('other wrong value'),
      R.strings.invalidField,
    );
  });

  test('should return error if values are different', () {
    final sut = CompareFieldValidation(
      field: 'any_field',
      valueToCompare: 'wrong value',
    );

    expect(sut.validate('wrong value'), null);
  });
}
