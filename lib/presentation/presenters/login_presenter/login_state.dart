class LoginState {
  String? email;
  String? password;
  bool loading = false;

  String? emailError;
  String? passwordError;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}
