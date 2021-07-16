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

  void mockLoadCurrentAccountSuccess({
    required AccountEntity? accountEntityResult,
  }) {
    mockLoadCurrentAccount().thenAnswer(
      (_) async => accountEntityResult,
    );
  }

  setUp(() {
    loadCurrentAccountUsecase = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(
      loadCurrentAccountUsecase: loadCurrentAccountUsecase,
    );

    mockLoadCurrentAccountSuccess(
      accountEntityResult: AccountEntity(token: faker.guid.guid()),
    );
  });

  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccountUsecase()).called(1);
  });

  test('should go to surveys page on success', () async {
    expectLater(sut.pushReplacementStream, emits('/surveys'));

    await sut.checkAccount();
  });

  test('should go to login page on null result', () async {
    mockLoadCurrentAccountSuccess(accountEntityResult: null);

    expectLater(sut.pushReplacementStream, emits('/login'));

    await sut.checkAccount();
  });
}
