import 'package:test/test.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    return null;
  }
}

abstract class FieldValidation {
  String get field;

  String? validate(String value);
}

void main() {
  test('should return null if value is not empty', () {
    final sut = RequiredFieldValidation('anyField');

    final error = sut.validate('any-value');

    expect(error, null);
  });
}
