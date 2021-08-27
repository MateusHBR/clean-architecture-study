import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

import 'package:course_clean_arch/data/http/http.dart';
import 'package:course_clean_arch/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient<Map> {}

typedef MockRequestReturn = When<Future<Map>>;

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  MockRequestReturn mockRequest() => when<Future<Map>>(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteAddAccount(
      httpClient: httpClient,
      url: url,
    );

    final password = faker.internet.password();

    params = AddAccountParams(
      name: faker.internet.userName(),
      email: faker.internet.email(),
      password: password,
      passwordConfirmation: password,
    );

    mockHttpData(mockValidData());
  });

  test('should call httpClient with correct values', () async {
    final password = faker.internet.password();

    final params = AddAccountParams(
      name: faker.internet.userName(),
      email: faker.internet.email(),
      password: password,
      passwordConfirmation: password,
    );

    await sut.call(params);

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
        body: {
          'name': params.name,
          'email': params.email,
          'password': params.password,
          'passwordConfirmation': params.passwordConfirmation,
        },
      ),
    ).called(1);
  });

  test('should throw unexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.call(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.call(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.call(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw invalidCredentialsError if HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.call(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();

    mockHttpData(validData);

    final account = await sut.call(params);

    expect(account.token, validData['accessToken']);
  });

  test(
      'should throw unexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalidValue'});

    final future = sut.call(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
