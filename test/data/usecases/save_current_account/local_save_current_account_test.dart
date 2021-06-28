import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:course_clean_arch/data/usecases/save_current_account/save_current_account.dart';

import 'package:course_clean_arch/domain/entities/account_entity.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

typedef SaveSecureExpectation = When<void>;
void main() {
  late SaveSecureCacheStorageSpy saveSecureCacheStorage;
  late LocalSaveCurrentAccount sut;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
    account = AccountEntity(token: faker.guid.guid());
  });

  SaveSecureExpectation mockExpectation() {
    return when(
      () => saveSecureCacheStorage(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    );
  }

  void mockSucess() {
    mockExpectation().thenAnswer((_) async => {});
  }

  void mockError() {
    mockExpectation().thenThrow(Exception());
  }

  test('Should call saveSecureCacheStorage with correct values', () async {
    mockSucess();

    await sut(account);

    verify(
      () => saveSecureCacheStorage(key: 'token', value: account.token),
    ).called(1);
  });

  test('Should throw unexpected error if saveSecureCacheStorage throws',
      () async {
    mockError();

    final future = sut(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
