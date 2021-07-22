import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

import 'package:course_clean_arch/data/http/http.dart';
import 'package:course_clean_arch/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

typedef MockRequestReturn = When<Future<Map>>;

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

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

    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
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
}