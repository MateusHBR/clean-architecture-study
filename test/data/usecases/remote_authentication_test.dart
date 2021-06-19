import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:course_clean_arch/domain/usecases/usecases.dart';

import 'package:course_clean_arch/data/usecases/usecases.dart';
import 'package:course_clean_arch/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );

    when(
      () => httpClient.request(
        url: url,
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenAnswer(
      (_) async => {},
    );
  });
  test('should call httpClient with correct values', () async {
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
}
