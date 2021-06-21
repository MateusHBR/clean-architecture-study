import 'dart:async';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

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

    expectLater(sut.emailErrorStream, emits('error'));

    sut.validateEmail(email);
  });
}

abstract class Validation {
  String? validate({required String field, required String value});
}

class LoginState {
  String? emailError;
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({
    required this.validation,
  });

  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String?> get emailErrorStream => _controller.stream.map(
        (state) => state.emailError,
      );

  void validateEmail(String email) {
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );

    _controller.add(_state);
  }
}
