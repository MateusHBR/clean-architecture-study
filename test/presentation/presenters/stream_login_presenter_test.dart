import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter sut;
  late ValidationSpy validation;
  late String email;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(
      validation: validation,
    );
    email = faker.internet.email();
  });
  test('should call validation with correct email', () {
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
