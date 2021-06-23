import 'dart:async';

import 'package:course_clean_arch/domain/helpers/helpers.dart';

import '../../../domain/usecases/usecases.dart';

import '../../../ui/pages/pages.dart';

import '../../protocols/protocols.dart';

import 'login_state.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authenticationUseCase;

  StreamLoginPresenter({
    required this.validation,
    required this.authenticationUseCase,
  });

  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String?> get emailErrorStream => _controller.stream
      .map(
        (state) => state.emailError,
      )
      .distinct();

  Stream<String?> get passwordErrorStream => _controller.stream
      .map(
        (state) => state.passwordError,
      )
      .distinct();

  Stream<bool> get isFormValidStream => _controller.stream
      .map(
        (state) => state.isFormValid,
      )
      .distinct();

  Stream<bool> get isLoadingStream => _controller.stream
      .map(
        (state) => state.loading,
      )
      .distinct();

  @override
  Stream<String?> get errorStream => _controller.stream
      .map(
        (state) => state.stateError,
      )
      .distinct();

  void _notifyListeners() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );

    _notifyListeners();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
    );

    _notifyListeners();
  }

  @override
  Future<void> authenticate() async {
    _state.stateError = null;
    _state.loading = true;
    _notifyListeners();

    try {
      await authenticationUseCase(
        AuthenticationParams(
          email: _state.email!,
          password: _state.password!,
        ),
      );
    } on DomainError catch (error) {
      _state.stateError = error.description;
    } finally {
      _state.loading = false;
      _notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
