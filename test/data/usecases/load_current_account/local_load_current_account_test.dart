import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/cache/fetch_secure_cache_storage.dart';
import 'package:course_clean_arch/data/usecases/usecases.dart';

class FetchSecureCacheStorageMock extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late LocalLoadCurrentAccount sut;
  late FetchSecureCacheStorageMock fetchSecureCacheStorage;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageMock();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    when(
      () => fetchSecureCacheStorage.fetchSecure(any()),
    ).thenAnswer(
      (_) async => {},
    );

    sut();

    verify(() async => fetchSecureCacheStorage.fetchSecure("token"));
  });
}
