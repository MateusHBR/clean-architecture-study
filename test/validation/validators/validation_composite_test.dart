import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/validation/protocols/protocols.dart';
import 'package:course_clean_arch/validation/validators/validators.dart';

class FieldValidationSpty extends Mock implements FieldValidation {}

typedef StringOrNullExpectation = When<String?>;
void main() {
  late ValidationComposite sut;
  late FieldValidationSpty validation1;
  late FieldValidationSpty validation2;

  StringOrNullExpectation mockFieldCall(FieldValidationSpty validationSpy) =>
      when(() => validationSpy.field);

  void mockField({
    required FieldValidationSpty validationSpy,
    required String? returnValue,
  }) {
    mockFieldCall(validationSpy).thenReturn(returnValue);
  }

  StringOrNullExpectation mockValidationCall(
          FieldValidationSpty validationSpy) =>
      when(() => validationSpy.validate(any()));

  void mockValidation({
    required FieldValidationSpty validationSpy,
    required String? returnValue,
  }) {
    mockValidationCall(validationSpy).thenReturn(returnValue);
  }

  setUp(() {
    validation1 = FieldValidationSpty();
    validation2 = FieldValidationSpty();

    sut = ValidationComposite(validations: [validation1, validation2]);
  });

  test('should return null if all validations returns null or empty', () {
    mockField(validationSpy: validation1, returnValue: 'field1');
    mockField(validationSpy: validation2, returnValue: 'field2');

    mockValidation(validationSpy: validation1, returnValue: null);
    mockValidation(validationSpy: validation2, returnValue: '');

    final errorFieldOne = sut.validate(field: 'field1', value: 'value');
    final errorFieldTwo = sut.validate(field: 'field2', value: 'value');

    expect(errorFieldOne, null);

    expect(errorFieldTwo, null);
  });
}
