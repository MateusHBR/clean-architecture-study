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
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    await client.post(
      Uri.parse(url),
      headers: headers,
    );
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late ClientSpy client;
  late String url;
  late Map<String, String> headers;
  late HttpAdapter sut;

  setUp(() {
    client = ClientSpy();
    url = faker.internet.httpUrl();

    headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    sut = HttpAdapter(client: client);
  });
  group('post', () {
    test('should call post with correct values', () async {
      when(
        () => client.post(
          Uri.parse(url),
          headers: headers,
        ),
      ).thenAnswer(
        (_) async => Response('mock-response', 200),
      );

      await sut.request(url: url, method: 'post');

      verify(
        () => client.post(
          Uri.parse(url),
          headers: headers,
        ),
      ).called(1);
    });
  });
}
