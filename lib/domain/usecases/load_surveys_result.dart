import '../entities/entities.dart';

abstract class LoadSurveysResult {
  Future<List<SurveyResultEntity>> call({String? surveyId});
}
