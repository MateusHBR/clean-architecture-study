import 'package:course_clean_arch/data/usecases/usecases.dart';
import 'package:course_clean_arch/domain/entities/survey_entity.dart';
import 'package:course_clean_arch/domain/helpers/domain_error.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remoteLoadSurveys;
  final LocalLoadSurveys localLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({
    required this.remoteLoadSurveys,
    required this.localLoadSurveys,
  });

  @override
  Future<List<SurveyEntity>> call() async {
    try {
      final remoteSurveys = await remoteLoadSurveys();

      await localLoadSurveys.save(remoteSurveys);

      return remoteSurveys;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await localLoadSurveys.validate();
      final localSurveys = await localLoadSurveys();
      return localSurveys;
    }
  }
}
