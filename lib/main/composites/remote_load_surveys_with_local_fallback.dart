import 'package:course_clean_arch/data/usecases/usecases.dart';
import 'package:course_clean_arch/domain/entities/survey_entity.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remoteLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({
    required this.remoteLoadSurveys,
  });

  @override
  Future<List<SurveyEntity>> call() async {
    final surveys = await remoteLoadSurveys();

    return surveys;
  }
}
