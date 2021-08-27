import 'package:course_clean_arch/data/models/models.dart';
import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/data/usecases/usecases.dart';

import 'package:course_clean_arch/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

typedef MockRequestReturn = When<Future<List<Map>>>;

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteLoadSurveys sut;

  MockRequestReturn mockRequest() => when<Future<List<Map>>>(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          // body: any(named: 'body'),
        ),
      );

  void mockHttpData(List<Map> data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'didAnswered': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'didAnswered': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
      ];

  setUp(() {
    url = faker.internet.httpUrl();

    httpClient = HttpClientSpy();

    sut = RemoteLoadSurveys(
      httpClient: httpClient,
      url: url,
    );
  });

  test('should call http client with correct values', () async {
    mockHttpData([{}]);

    await sut();

    verify(() => httpClient.request(url: url, method: 'get')).called(1);
  });

  test('should return surveys on 200', () async {
    final data = mockValidData();
    final modelData = data
        .map(
          (json) => RemoteSurveysModel.fromJson(json),
        )
        .toList();

    final convertedData = modelData
        .map(
          (model) => model.toEntity(),
        )
        .toList();

    mockHttpData(data);

    final response = await sut();

    expect(convertedData, response);
  });

  test(
      'should throw unexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData([
      {'invalid_key': 'invalidValue'}
    ]);

    final future = sut();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw unexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut();

    expect(future, throwsA(DomainError.unexpected));
  });
}
