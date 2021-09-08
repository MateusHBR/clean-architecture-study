import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:course_clean_arch/data/cache/cache.dart';
import 'package:course_clean_arch/data/usecases/usecases.dart';
import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/domain/entities/entities.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

typedef CacheExpectation = When<Future<dynamic>>;

void main() {
  group('load', () {
    late CacheStorageSpy cacheStorage;
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
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(
        cacheStorage: cacheStorage,
      );
    });

    CacheExpectation mockFetchCache() => when(
          () => cacheStorage.fetch(any()),
        );

    void mockFetchSuccess({
      required List<Map<String, String>>? response,
    }) {
      mockFetchCache().thenAnswer(
        (_) async => response,
      );
    }

    void mockFetchError() {
      mockFetchCache().thenThrow(Exception());
    }

    test('Should call cacheStorage with correct key', () async {
      mockFetchSuccess(
        response: data,
      );

      await sut();

      verify(() => cacheStorage.fetch('surveys'));
    });

    test('Should return a list of surveys on success', () async {
      mockFetchSuccess(
        response: data,
      );

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

    test('should throw unexpectedError if cache is empty', () {
      mockFetchSuccess(response: []);

      final future = sut();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw unexpectedError if cache is empty', () {
      mockFetchSuccess(response: null);

      final future = sut();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw unexpectedError if cache is invalid', () {
      mockFetchSuccess(
        response: [
          {
            'id': faker.guid.guid(),
            'didAnswer': 'true',
          },
        ],
      );

      final future = sut();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw unexpectedError if cache is invalid', () {
      mockFetchError();

      final future = sut();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    late CacheStorageSpy cacheStorage;
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
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(
        cacheStorage: cacheStorage,
      );
    });

    CacheExpectation mockFetchCache() => when(
          () => cacheStorage.fetch(any()),
        );

    When<Future<void>> mockDeleteCache() => when(
          () => cacheStorage.delete(any()),
        );

    void mockFetchSuccess({
      required List<Map<String, String>>? response,
    }) {
      mockFetchCache().thenAnswer(
        (_) async => response,
      );
    }

    void mockDeleteCacheSuccess() {
      mockDeleteCache().thenAnswer(
        (_) async => {},
      );
    }

    void mockFetchError() {
      mockFetchCache().thenThrow(Exception());
    }

    void mockDeleteCacheError() {
      mockDeleteCache().thenThrow(Exception());
    }

    test('Should call cacheStorage with correct key', () async {
      mockFetchSuccess(
        response: data,
      );

      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if is invalid', () async {
      mockFetchSuccess(
        response: [
          {
            'date': 'DateTime(2018).toIso8601String()',
            'id': faker.guid.guid(),
            'didAnswer': 'true',
            'question': faker.randomGenerator.string(10),
          }
        ],
      );
      mockDeleteCacheSuccess();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetchSuccess(
        response: [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
          }
        ],
      );
      mockDeleteCacheSuccess();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetchError();
      mockDeleteCacheSuccess();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('validate', () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveys sut;
    late List<SurveyEntity> surveys;

    List<SurveyEntity> mockSurveys() => [
          SurveyEntity(
            id: faker.guid.guid(),
            date: DateTime.utc(2021, 20, 2),
            question: faker.randomGenerator.string(10),
            didAnswer: true,
          ),
          SurveyEntity(
            id: faker.guid.guid(),
            date: DateTime.utc(2018, 20, 2),
            question: faker.randomGenerator.string(10),
            didAnswer: true,
          ),
        ];

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(
        cacheStorage: cacheStorage,
      );
      surveys = mockSurveys();
    });

    When<Future<void>> mockSaveCache() => when(
          () => cacheStorage.save(
              key: any(named: 'key'), value: any(named: 'value')),
        );

    void mockSaveCacheSuccess() {
      mockSaveCache().thenAnswer(
        (_) async => {},
      );
    }

    void mockSaveCacheError() {
      mockSaveCache().thenThrow(Exception());
    }

    test('Should call cacheStorage with correct values', () async {
      mockSaveCacheSuccess();

      final list = [
        {
          'id': surveys[0].id,
          'date': surveys[0].date.toIso8601String(),
          'didAnswer': surveys[0].didAnswer.toString(),
          'question': surveys[0].question,
        },
        {
          'id': surveys[1].id,
          'date': surveys[1].date.toIso8601String(),
          'didAnswer': surveys[1].didAnswer.toString(),
          'question': surveys[1].question,
        },
      ];

      await sut.save(surveys);

      verify(
        () => cacheStorage.save<List<Map>>(key: 'surveys', value: list),
      ).called(1);
    });

    test('Should throw DomainError.unexpected when cache.save throws',
        () async {
      mockSaveCacheError();
      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
