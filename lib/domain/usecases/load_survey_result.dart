import '../entities/entities.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> call({String? surveyId});
}
