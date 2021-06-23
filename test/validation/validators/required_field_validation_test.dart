import 'package:test/test.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    if (value.isEmpty) {
      return 'Campo obrigatório.';
    }

    return null;
  }
}

abstract class FieldValidation {
  String get field;

  String? validate(String value);
}

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
}
