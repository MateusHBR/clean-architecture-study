import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/utils/i18n/i18n.dart';

import 'package:course_clean_arch/domain/entities/entities.dart';
import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

import 'package:course_clean_arch/presentation/presenters/presenters.dart';
import 'package:course_clean_arch/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

typedef ValidationExpectation = When<String?>;
typedef FutureVoidExpectation = When<Future<void>>;

void main() {
  late GetxSignupPresenter sut;
  late ValidationSpy validation;
  late String email;
  late String name;

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
    sut = GetxSignupPresenter(
      validation: validation,
    );
    email = faker.internet.email();
    name = faker.internet.userName();

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

  test('should call validation with correct name', () {
    sut.validateName(name);

    verify(
      () => validation.validate(
        value: name,
        field: 'name',
      ),
    ).called(1);
  });

  test('should emit name error if validation fails', () {
    mockValidation(value: 'error');

    sut.nameErrorStream.listen(
      expectAsync1((error) => expect(error, 'error')),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    sut.validateName(name);
    sut.validateName(name);
  });

  test(
      'should emit null if validation name succeeds and prevents duplicated events',
      () {
    sut.nameErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    sut.validateName(name);
    sut.validateName(name);
  });
}
