import '../../../data/cache/cache.dart';
import '../../../data/models/models.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({
    required this.cacheStorage,
  });

  @override
  Future<List<SurveyEntity>> call() async {
    try {
      final data = await cacheStorage.fetch('surveys');

      if (data?.isEmpty != false) {
        throw DomainError.unexpected;
      }

      return _map(data);
    } on DomainError {
      rethrow;
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');

      _map(data);
    } catch (_) {
      cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    await cacheStorage.save<List<Map>>(
      key: 'surveys',
      value: _mapToJson(surveys),
    );
  }

  List<SurveyEntity> _map(List<Map> list) {
    return list.map<SurveyEntity>((json) {
      return LocalSurveysModel.fromJson(json).toEntity();
    }).toList();
  }

  List<Map<String, String>> _mapToJson(List<SurveyEntity> list) {
    return list.map((survey) {
      return LocalSurveysModel.fromEntity(survey).toJson();
    }).toList();
  }
}
