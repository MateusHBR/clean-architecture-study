import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:get/state_manager.dart';

import '../../../domain/usecases/usecases.dart';

import '../../../ui/pages/splash/splash.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccountUsecase;

  GetxSplashPresenter({required this.loadCurrentAccountUsecase});

  final _pushReplacementSubject = Rx<String?>('');

  @override
  Stream<String?> get pushReplacementStream => _pushReplacementSubject.stream;

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));

    try {
      final accountResponse = await loadCurrentAccountUsecase();
      print(accountResponse?.token);
      if (accountResponse != null) {
        _pushReplacementSubject.value = '/surveys';
      } else {
        _pushReplacementSubject.value = '/login';
      }
    } on DomainError {
      _pushReplacementSubject.value = '/login';
    }
  }
}
