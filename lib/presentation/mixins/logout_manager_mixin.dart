import 'package:get/get.dart';

mixin LogoutManager on GetxController {
  final _isSessionExpiredObservable = Rx<bool>(false);

  Stream<bool> get isSessionExpiredStream =>
      _isSessionExpiredObservable.stream as Stream<bool>;

  void setExpiredSession() => _isSessionExpiredObservable.value = true;
}
