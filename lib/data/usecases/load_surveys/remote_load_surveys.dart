import 'package:course_clean_arch/data/http/http.dart';
import 'package:course_clean_arch/domain/entities/survey_entity.dart';

import '../../../domain/usecases/usecases.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<List<SurveyEntity>> call() async {
    await httpClient.request(url: url, method: 'get');

    return [];
  }
}
