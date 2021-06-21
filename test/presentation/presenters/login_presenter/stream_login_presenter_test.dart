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
  late String password;

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
    password = faker.internet.password();

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

  test(
      'should emit null if validation email succeeds and prevents duplicated events',
      () {
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('should call validation with correct password', () {
    sut.validatePassword(password);

    verify(
      () => validation.validate(
        value: password,
        field: 'password',
      ),
    ).called(1);
  });

  test(
      'should emit password error if validation fails and prevents duplicated events',
      () {
    mockValidation(value: 'error');

    sut.passwordErrorStream.listen(
      expectAsync1((error) => 'error'),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test(
      'should emit null if validation password succeeds and prevents duplicated events',
      () {
    sut.passwordErrorStream.listen(
      expectAsync1((error) => null),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test(
      'email should emit error and password dont, but form should not be valid',
      () {
    mockValidation(field: 'email', value: 'error');

    sut.passwordErrorStream.listen(
      expectAsync1((error) => null),
    );

    sut.emailErrorStream.listen(
      expectAsync1((error) => 'error'),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);
  });
}
