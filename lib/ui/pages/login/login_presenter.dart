abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get isErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void authenticate();
  void dispose();
}
