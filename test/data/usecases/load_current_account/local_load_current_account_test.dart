import 'package:course_clean_arch/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/cache/fetch_secure_cache_storage.dart';
import 'package:course_clean_arch/data/usecases/usecases.dart';

class FetchSecureCacheStorageMock extends Mock
    implements FetchSecureCacheStorage {}

typedef FetchSecureExpectation = When<Future<String>>;
void main() {
  late LocalLoadCurrentAccount sut;
  late FetchSecureCacheStorageMock fetchSecureCacheStorage;

  FetchSecureExpectation mockfetchSecure() => when(
        () => fetchSecureCacheStorage.fetchSecure(any()),
      );

  void mockfetchSecureSuccess([String? token]) {
    if (token == null) {
      token = faker.guid.guid();
    }

    mockfetchSecure().thenAnswer(
      (_) async => token!,
    );
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageMock();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );

    mockfetchSecureSuccess();
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    sut();

    verify(
      () => fetchSecureCacheStorage.fetchSecure("token"),
    ).called(1);
  });

  test('should return AccountEntity', () async {
    final token = faker.guid.guid();
    mockfetchSecureSuccess(token);

    final account = await sut();

    expect(
      account,
      AccountEntity(token: token),
    );
  });
}
