import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({
    required this.client,
  });

  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    return response.body.isEmpty ? {} : jsonDecode(response.body);
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
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => Response('{"any_key":"any_value"}', 200),
      );

      await sut.request(
        url: url,
        method: 'post',
        body: {
          'any_key': 'any_value',
        },
      );

      verify(
        () => client.post(
          Uri.parse(url),
          headers: headers,
          body: '{"any_key":"any_value"}',
        ),
      ).called(1);
    });

    test('should call post without body', () async {
      when(
        () => client.post(
          Uri.parse(url),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Response('{"any_key":"any_value"}', 200),
      );

      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        () => client.post(
          Uri.parse(url),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });

    test('should return data if post returns 200', () async {
      when(
        () => client.post(
          Uri.parse(url),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Response('{"any_key":"any_value"}', 200),
      );

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, {'any_key': 'any_value'});
    });

    test('should empty map if post returns 200 with no data', () async {
      when(
        () => client.post(
          Uri.parse(url),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Response('', 200),
      );

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, {});
    });
  });
}
