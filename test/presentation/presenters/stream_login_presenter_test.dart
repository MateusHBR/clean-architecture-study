import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  test('should call validation with correct email', () {
    final validation = ValidationSpy();
    final sut = StreamLoginPresenter(
      validation: validation,
    );

    final email = faker.internet.email();

    sut.validateEmail(email);

    verify(
      () => validation.validate(
        value: email,
        field: 'email',
      ),
    ).called(1);
  });
}

abstract class Validation {
  String? validate({required String field, required String value});
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({
    required this.validation,
  });

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}
