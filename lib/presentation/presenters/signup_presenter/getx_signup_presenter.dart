import 'dart:async';

import 'package:get/state_manager.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';

import '../../../ui/pages/pages.dart';

import '../../protocols/protocols.dart';

class GetxSignupPresenter extends GetxController {
  final Validation validation;

  GetxSignupPresenter({
    required this.validation,
  });

  String _email = '';
  String _name = '';
  String _password = '';
  String _passwordConfirmation = '';
  final _emailErrorObserver = Rx<String?>(null);
  final _nameErrorObserver = Rx<String?>(null);
  final _passwordErrorObserver = Rx<String?>(null);
  final _passwordConfirmationErrorObserver = Rx<String?>(null);
  final _errorObserver = Rx<String?>(null);
  final _formValidObserver = Rx<bool>(false);
  final _loadingObserver = Rx<bool>(false);
  final _pushNamedAndRemoveUntilStreamObserver = Rx<String?>(null);

  @override
  Stream<String?> get emailErrorStream => _emailErrorObserver.stream.distinct();

  @override
  Stream<String?> get nameErrorStream => _nameErrorObserver.stream.distinct();

  @override
  Stream<String?> get passwordErrorStream =>
      _passwordErrorObserver.stream.distinct();

  @override
  Stream<String?> get passwordConfirmationErrorStream =>
      _passwordConfirmationErrorObserver.stream.distinct();

  @override
  Stream<bool> get isFormValidStream =>
      _formValidObserver.stream as Stream<bool>;

  @override
  Stream<bool> get isLoadingStream => _loadingObserver.stream as Stream<bool>;

  @override
  Stream<String?> get errorStream => _errorObserver.stream.distinct();

  @override
  Stream<String?> get pushNamedAndRemoveUntilStream =>
      _pushNamedAndRemoveUntilStreamObserver.stream.distinct();

  void _validateForm() {
    // final emailWithoutError = _emailErrorObserver.value == null;
    // final emailIsNotNull = _email.isNotEmpty;
    // final passwordIsNotNull = _password.isNotEmpty;

    _formValidObserver.value = false;
    //     emailWithoutError && emailIsNotNull && passwordIsNotNull;
  }

  void validateEmail(String email) {
    _email = email;

    _emailErrorObserver.value = validation.validate(
      field: 'email',
      value: email,
    );

    _validateForm();
  }

  void validateName(String name) {
    _name = name;

    _nameErrorObserver.value = validation.validate(
      field: 'name',
      value: name,
    );

    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;

    _passwordErrorObserver.value = validation.validate(
      field: 'password',
      value: password,
    );

    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;

    _passwordConfirmationErrorObserver.value = validation.validate(
      field: 'passwordConfirmation',
      value: passwordConfirmation,
    );

    _validateForm();
  }

  // @override
  // Future<void> authenticate() async {
  //   _loadingObserver.value = true;

  //   try {
  //     final token = await authenticationUseCase(
  //       AuthenticationParams(
  //         email: _email,
  //         password: _password,
  //       ),
  //     );

  //     saveCurrentAccountUseCase(token);

  //     _pushNamedAndRemoveUntilStreamObserver.value = '/surveys';
  //   } on DomainError catch (error) {
  //     _errorObserver.value = error.description;
  //     _errorObserver.value = null;
  //     _loadingObserver.value = false;
  //   }
  // }
}
