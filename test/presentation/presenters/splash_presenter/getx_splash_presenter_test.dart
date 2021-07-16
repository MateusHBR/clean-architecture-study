import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/domain/usecases/usecases.dart';
import 'package:course_clean_arch/domain/entities/entities.dart';

import 'package:course_clean_arch/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccountUsecase;
  late GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccountUsecase = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(
      loadCurrentAccountUsecase: loadCurrentAccountUsecase,
    );
  });

  test('should call LoadCurrentAccount', () async {
    when(
      () => loadCurrentAccountUsecase(),
    ).thenAnswer(
      (_) async => AccountEntity(token: faker.guid.guid()),
    );

    await sut.checkAccount();

    verify(() => loadCurrentAccountUsecase()).called(1);
  });
}