import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter({
    required this.client,
  });

  Future<void> request({
    required String url,
    required String method,
  }) async {
    await client.post(Uri.parse(url));
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('post', () {
    test('should call post with correct values', () async {
      final client = ClientSpy();
      final url = faker.internet.httpUrl();
      final sut = HttpAdapter(client: client);

      when(
        () => client.post(Uri.parse(url)),
      ).thenAnswer(
        (_) async => Response('mock-response', 200),
      );

      await sut.request(url: url, method: 'post');

      verify(
        () => client.post(Uri.parse(url)),
      ).called(1);
    });
  });
}
