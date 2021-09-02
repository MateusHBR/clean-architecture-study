import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/cache/cache.dart';
import 'package:course_clean_arch/data/http/http.dart';

import 'package:course_clean_arch/main/decorators/decorators.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorageSpy;
  late HttpClientSpy httpClientSpy;
  late AuthorizeHttpClientDecorator sut;

  setUp(() {
    httpClientSpy = HttpClientSpy();
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
      httpClient: httpClientSpy,
    );

    when(
      () => fetchSecureCacheStorageSpy.fetchSecure(any()),
    ).thenAnswer(
      (invocation) async => "answer-token",
    );

    when(
      () => httpClientSpy.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer(
      (invocation) async => {},
    );
  });

  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: 'url', method: 'post');

    verify(
      () => fetchSecureCacheStorageSpy.fetchSecure('token'),
    ).called(1);
  });

  test('should call decoratee with access token on header', () async {
    final url = faker.internet.httpUrl();
    await sut.request(
      url: url,
      method: 'post',
      body: {},
    );

    verify(
      () => httpClientSpy.request(
        url: url,
        method: 'post',
        body: {},
        headers: {
          'x-access-token': 'answer-token',
        },
      ),
    ).called(1);
  });
}
