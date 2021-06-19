import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/http/http.dart';

import 'package:course_clean_arch/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

typedef PostExpectationResponse = When<Future<Response>>;

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
    PostExpectationResponse mockRequest() => when(
          () => client.post(
            Uri.parse(url),
            headers: headers,
            body: any(named: 'body'),
          ),
        );

    void mockResponse({
      required int statusCode,
      String body = '{"any_key":"any_value"}',
    }) {
      mockRequest().thenAnswer(
        (_) async => Response(body, statusCode),
      );
    }

    setUp(() {
      mockResponse(statusCode: 200);
    });

    test('should call post with correct values', () async {
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
      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, {'any_key': 'any_value'});
    });

    test('should return empty map if post returns 200 with no data', () async {
      mockResponse(statusCode: 200, body: '');

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, {});
    });

    test('should return empty map if post returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, {});
    });

    test('should return empty map if post returns 204 with data', () async {
      mockResponse(statusCode: 204);

      final response = await sut.request(
        url: url,
        method: 'post',
      );

      expect(response, {});
    });

    test('should return BarRequestError if post returns 400 with data',
        () async {
      mockResponse(statusCode: 400, body: '');

      final future = sut.request(
        url: url,
        method: 'post',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BarRequestError if post returns 400', () async {
      mockResponse(statusCode: 400);

      final future = sut.request(
        url: url,
        method: 'post',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return Unauthorized if post returns 401', () async {
      mockResponse(statusCode: 401);

      final future = sut.request(
        url: url,
        method: 'post',
      );

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return forbidden if post returns 403', () async {
      mockResponse(statusCode: 403);

      final future = sut.request(
        url: url,
        method: 'post',
      );

      expect(future, throwsA(HttpError.forbidden));
    });
    test('should return notFound if post returns 404', () async {
      mockResponse(statusCode: 404);

      final future = sut.request(
        url: url,
        method: 'post',
      );

      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerError if post returns 500', () async {
      mockResponse(statusCode: 500);

      final future = sut.request(
        url: url,
        method: 'post',
      );

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
