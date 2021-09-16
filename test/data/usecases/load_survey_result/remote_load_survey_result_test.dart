import 'package:course_clean_arch/data/models/models.dart';
import 'package:course_clean_arch/domain/helpers/helpers.dart';
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
  late RemoteLoadSurveyResult sut;

  MockRequestReturn mockRequest() => when<Future<Map>>(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
        ) as Future<Map>,
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  Map mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  setUp(() {
    url = faker.internet.httpUrl();

    httpClient = HttpClientSpy();

    sut = RemoteLoadSurveyResult(
      httpClient: httpClient,
      url: url,
    );
  });

  test('should call http client with correct values', () async {
    mockHttpData(mockValidData());

    await sut();

    verify(() => httpClient.request(url: url, method: 'get')).called(1);
  });

  test('should return survey result on 200', () async {
    final data = mockValidData();
    final modelData = RemoteSurveyResultModel.fromJson(data);
    final convertedData = modelData.toEntity();

    mockHttpData(data);

    final response = await sut();

    expect(convertedData, response);
  });

  test(
      'should throw unexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalidValue'});

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

  test('should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
