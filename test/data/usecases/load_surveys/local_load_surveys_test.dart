import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:course_clean_arch/data/usecases/usecases.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

typedef FetchCacheExpectation = When<Future<void>>;

void main() {
  late FetchCacheStorageSpy fetchCacheStorage;
  late LocalLoadSurveys sut;

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
    mockFetchCache().thenAnswer((_) async => {});
  }

  test('Should call FetchCacheStorage with correct key', () async {
    mockFetchSuccess();

    await sut();

    verify(() => fetchCacheStorage('surveys'));
  });
}
