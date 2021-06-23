abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get errorStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> authenticate();
  void dispose();
}
