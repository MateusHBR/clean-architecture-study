class LoginState {
  String? email;
  String? password;

  String? emailError;
  String? passwordError;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}
