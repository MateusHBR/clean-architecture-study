import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/presentation/presenters/presenters.dart';
import 'package:course_clean_arch/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

typedef ValidationExpectation = When<String?>;

void main() {
  late StreamLoginPresenter sut;
  late ValidationSpy validation;
  late String email;

  ValidationExpectation mockValidationCall({String? field}) => when(
        () => validation.validate(
          field: field == null ? any(named: 'field') : field,
          value: any(named: 'value'),
        ),
      );

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(
      validation: validation,
    );
    email = faker.internet.email();
    mockValidation();
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

  test('should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, 'error')),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
