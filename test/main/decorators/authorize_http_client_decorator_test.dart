import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/main/decorators/decorators.dart';
import 'package:course_clean_arch/data/cache/cache.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorageSpy;
  late AuthorizeHttpClientDecorator sut;

  setUp(() {
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
    );

    when(
      () => fetchSecureCacheStorageSpy.fetchSecure(any()),
    ).thenAnswer(
      (invocation) async => "answer-token",
    );
  });

  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: 'url', method: 'post');

    verify(
      () => fetchSecureCacheStorageSpy.fetchSecure('token'),
    ).called(1);
  });
}
