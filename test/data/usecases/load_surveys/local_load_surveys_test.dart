import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:course_clean_arch/domain/entities/entities.dart';
import 'package:course_clean_arch/data/usecases/usecases.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

typedef FetchCacheExpectation = When<Future<dynamic>>;

void main() {
  late FetchCacheStorageSpy fetchCacheStorage;
  late LocalLoadSurveys sut;
  final data = [
    {
      'date': DateTime(2018).toIso8601String(),
      'id': faker.guid.guid(),
      'didAnswer': 'true',
      'question': faker.randomGenerator.string(10),
    },
    {
      'date': DateTime(2021).toIso8601String(),
      'id': faker.guid.guid(),
      'didAnswer': 'true',
      'question': faker.randomGenerator.string(10),
    },
  ];

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(
      fetchCacheStorage: fetchCacheStorage,
    );
  });

  FetchCacheExpectation mockFetchCache() => when(
        () => fetchCacheStorage(any()),
      );

  void mockFetchSuccess() {
    mockFetchCache().thenAnswer(
      (_) async => data,
    );
  }

  test('Should call FetchCacheStorage with correct key', () async {
    mockFetchSuccess();

    await sut();

    verify(() => fetchCacheStorage('surveys'));
  });

  test('Should return a list of surveys on success', () async {
    mockFetchSuccess();

    final surveys = await sut();

    expect(
      surveys,
      [
        SurveyEntity(
          id: data[0]['id']!,
          didAnswer: bool.fromEnvironment(data[0]['didAnswer']!),
          question: data[0]['question']!,
          date: DateTime.parse(data[0]['date']!),
        ),
        SurveyEntity(
          id: data[1]['id']!,
          didAnswer: bool.fromEnvironment(data[1]['didAnswer']!),
          question: data[1]['question']!,
          date: DateTime.parse(data[1]['date']!),
        ),
      ],
    );
  });
}
