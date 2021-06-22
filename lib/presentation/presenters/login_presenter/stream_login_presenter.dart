import 'dart:async';

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
    await authenticationUseCase(
      AuthenticationParams(email: _state.email!, password: _state.password!),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement isErrorStream
  Stream<String?> get isErrorStream => throw UnimplementedError();

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();
}
