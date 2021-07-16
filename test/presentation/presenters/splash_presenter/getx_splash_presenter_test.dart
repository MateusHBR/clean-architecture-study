import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/domain/usecases/usecases.dart';
import 'package:course_clean_arch/domain/entities/entities.dart';

import 'package:course_clean_arch/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

typedef AccountExpectation = When<Future<AccountEntity?>>;
void main() {
  late LoadCurrentAccountSpy loadCurrentAccountUsecase;
  late GetxSplashPresenter sut;

  AccountExpectation mockLoadCurrentAccount() => when(
        () => loadCurrentAccountUsecase(),
      );

  void mockLoadCurrentAccountSuccess({String? token}) {
    mockLoadCurrentAccount().thenAnswer(
      (_) async => AccountEntity(token: token ?? faker.guid.guid()),
    );
  }

  setUp(() {
    loadCurrentAccountUsecase = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(
      loadCurrentAccountUsecase: loadCurrentAccountUsecase,
    );

    mockLoadCurrentAccountSuccess();
  });

  test('should call LoadCurrentAccount', () async {
    mockLoadCurrentAccountSuccess();

    await sut.checkAccount();

    verify(() => loadCurrentAccountUsecase()).called(1);
  });

  test('should go to surveys page on success', () async {
    expectLater(sut.pushReplacementStream, emits('/surveys'));

    await sut.checkAccount();
  });
}
