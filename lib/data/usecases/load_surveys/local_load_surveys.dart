import '../../../data/models/models.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

abstract class FetchCacheStorage {
  Future<dynamic> call(String key);
}

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({
    required this.fetchCacheStorage,
  });

  @override
  Future<List<SurveyEntity>> call() async {
    final data = await fetchCacheStorage('surveys');

    if (data?.isEmpty != false) {
      throw DomainError.unexpected;
    }

    return data.map<SurveyEntity>((json) {
      return LocalSurveysModel.fromJson(json).toEntity();
    }).toList();
  }
}
