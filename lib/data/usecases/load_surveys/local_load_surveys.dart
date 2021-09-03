import 'package:course_clean_arch/domain/entities/survey_entity.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

abstract class FetchCacheStorage {
  Future<void> call(String key);
}

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({
    required this.fetchCacheStorage,
  });

  @override
  Future<List<SurveyEntity>> call() async {
    await fetchCacheStorage('surveys');
    return [];
  }
}
