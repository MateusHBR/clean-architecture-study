import 'package:get/get.dart';

mixin LogoutManager {
  final _isSessionExpiredObservable = Rx<bool>(false);

  Stream<bool> get isSessionExpiredStream =>
      _isSessionExpiredObservable.stream as Stream<bool>;

  void setExpiredSession() => _isSessionExpiredObservable.value = true;
}
