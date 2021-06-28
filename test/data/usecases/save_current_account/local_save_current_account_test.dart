import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:course_clean_arch/data/usecases/save_current_account/save_current_account.dart';

import 'package:course_clean_arch/domain/entities/account_entity.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  test('Should call saveSecureCacheStorage with correct values', () async {
    final saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    final sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final account = AccountEntity(token: faker.guid.guid());

    when(
      () => saveSecureCacheStorage(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async => {});

    await sut(account);

    verify(
      () => saveSecureCacheStorage(key: 'token', value: account.token),
    ).called(1);
  });

  test('Should throw unexpected error if saveSecureCacheStorage throws',
      () async {
    final saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    final sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final account = AccountEntity(token: faker.guid.guid());

    when(
      () => saveSecureCacheStorage(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenThrow(Exception());

    final future = sut(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
