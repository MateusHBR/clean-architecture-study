import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:course_clean_arch/data/usecases/save_current_account/save_current_account.dart';

import 'package:course_clean_arch/domain/entities/account_entity.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  test('Should call cacheStorage with correct values', () async {
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
}
