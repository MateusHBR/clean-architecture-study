import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/domain/entities/entities.dart';
import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

import 'package:course_clean_arch/presentation/presenters/presenters.dart';
import 'package:course_clean_arch/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

typedef ValidationExpectation = When<String?>;
typedef AuthenticationExpectation = When<Future<AccountEntity>>;
typedef FutureVoidExpectation = When<Future<void>>;

void main() {
  late GetxLoginPresenter sut;
  late ValidationSpy validation;
  late AuthenticationSpy authenticationUseCase;
  late SaveCurrentAccountSpy saveCurrentAccountUseCase;
  late String email;
  late String password;
  late String defaultToken;

  FutureVoidExpectation mockSaveCurrentAccountCall(String token) {
    return when(
      () => saveCurrentAccountUseCase(
        AccountEntity(token: token),
      ),
    );
  }

  void mockSaveCurrentAccountSuccess({required String token}) {
    mockSaveCurrentAccountCall(token).thenAnswer((_) async => {});
  }

  void mockSaveCurrentAccountError({required String token}) {
    mockSaveCurrentAccountCall(token).thenThrow(DomainError.unexpected);
  }

  ValidationExpectation mockValidationCall({String? field}) => when(
        () => validation.validate(
          field: field == null ? any(named: 'field') : field,
          value: any(named: 'value'),
        ),
      );

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  AuthenticationExpectation mockAuthenticationCall({
    required String email,
    required String password,
  }) =>
      when(
        () => authenticationUseCase(
          AuthenticationParams(
            email: email,
            password: password,
          ),
        ),
      );

  void mockAuthentication({
    required String email,
    required String password,
    String? token,
  }) {
    mockAuthenticationCall(email: email, password: password).thenAnswer(
      (_) async => AccountEntity(token: token ?? defaultToken),
    );
  }

  void mockAuthenticationError({
    required String email,
    required String password,
    required DomainError error,
  }) {
    mockAuthenticationCall(email: email, password: password).thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authenticationUseCase = AuthenticationSpy();
    saveCurrentAccountUseCase = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authenticationUseCase: authenticationUseCase,
      saveCurrentAccountUseCase: saveCurrentAccountUseCase,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    defaultToken = faker.guid.guid();

    mockValidation();
    mockSaveCurrentAccountSuccess(token: defaultToken);
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
    sut.validateEmail(password);
  });
  test(
      'email should emit error and password dont, but form should not be valid',
      () async {
    sut.passwordErrorStream.listen(
      expectAsync1((error) => null),
    );

    sut.emailErrorStream.listen(
      expectAsync1((error) => null),
    );

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateEmail(password);
  });

  test('should call authentication with correct values', () async {
    mockAuthentication(email: email, password: password);

    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.authenticate();

    verify(
      () => authenticationUseCase(
        AuthenticationParams(email: email, password: password),
      ),
    ).called(1);
  });

  test('should emit correct events on Authentication success', () async {
    mockAuthentication(email: email, password: password);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.authenticate();
  });

  test('should emit correct events on invalid credentials error', () async {
    mockAuthenticationError(
      email: email,
      password: password,
      error: DomainError.invalidCredentials,
    );

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
      sut.errorStream,
      emitsInOrder([R.strings.invalidCredentials, null]),
    );

    await sut.authenticate();
  });

  test('should emit correct events on unexpected error', () async {
    mockAuthenticationError(
      email: email,
      password: password,
      error: DomainError.unexpected,
    );

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
      sut.errorStream,
      emitsInOrder([R.strings.unexpectedErrorTryAgain, null]),
    );

    await sut.authenticate();
  });

  test('should call SaveCurrentAccount with correct value', () async {
    final token = faker.guid.guid();

    mockAuthentication(email: email, password: password, token: token);
    mockSaveCurrentAccountSuccess(token: token);

    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.authenticate();

    verify(
      () => saveCurrentAccountUseCase(AccountEntity(token: token)),
    ).called(1);
  });

  test('should call UnexpectedError if saveCurrentAccount fails', () async {
    final token = faker.guid.guid();

    mockAuthentication(email: email, password: password, token: token);
    mockSaveCurrentAccountError(token: token);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(
      sut.errorStream,
      emitsInOrder([R.strings.unexpectedErrorTryAgain, null]),
    );

    await sut.authenticate();
  });

  test('should change page on success', () async {
    mockAuthentication(email: email, password: password);

    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.pushNamedAndRemoveUntilStream.listen(
      expectAsync1((route) => expect(route, '/surveys')),
    );

    await sut.authenticate();
  });
}
