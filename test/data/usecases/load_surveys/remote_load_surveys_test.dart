import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/usecases/usecases.dart';

import 'package:course_clean_arch/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

typedef MockRequestReturn = When<Future<Map>>;

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteLoadSurveys sut;

  setUp(() {
    url = faker.internet.httpUrl();

    httpClient = HttpClientSpy();

    sut = RemoteLoadSurveys(
      httpClient: httpClient,
      url: url,
    );
  });

  MockRequestReturn mockRequest() => when<Future<Map>>(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          // body: any(named: 'body'),
        ),
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  test('should call http client with correct values', () async {
    mockHttpData({});

    await sut();

    verify(() => httpClient.request(url: url, method: 'get')).called(1);
  });
}
