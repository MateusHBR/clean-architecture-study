import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/main/decorators/decorators.dart';
import 'package:course_clean_arch/data/cache/cache.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  setUp(() {});

  test('should call FetchSecureCacheStorage with correct key', () async {
    final fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    final sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
    );

    when(
      () => fetchSecureCacheStorageSpy.fetchSecure(any()),
    ).thenAnswer(
      (invocation) async => "token",
    );

    await sut.request(url: 'url', method: 'post');

    verify(
      () => fetchSecureCacheStorageSpy.fetchSecure('token'),
    ).called(1);
  });
}
