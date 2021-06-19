import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({
    required String url,
    required String method,
  });
}

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
      () => httpClient.request(url: url, method: any(named: 'method')),
    ).thenAnswer(
      (_) async => {},
    );
  });
  test('should call httpClient with correct values', () async {
    await sut.auth();

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
      ),
    ).called(1);
  });
}
