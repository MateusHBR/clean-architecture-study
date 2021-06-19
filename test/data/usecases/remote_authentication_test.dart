import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

import 'package:course_clean_arch/data/http/http.dart';
import 'package:course_clean_arch/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );

    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });
  test('should call httpClient with correct values', () async {
    when(
      () => httpClient.request(
        url: url,
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenAnswer(
      (_) async => {},
    );

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    await sut.auth(params);

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
        body: {
          'email': params.email,
          'password': params.password,
        },
      ),
    ).called(1);
  });

  test('should throw unexpectedError if HttpClient returns 400', () async {
    when(
      () => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpectedError if HttpClient returns 404', () async {
    when(
      () => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpectedError if HttpClient returns 500', () async {
    when(
      () => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
