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
  Future<void> checkAccount() async {
    final accountResponse = await loadCurrentAccountUsecase();

    _pushReplacementSubject.value = '/surveys';
  }
}
