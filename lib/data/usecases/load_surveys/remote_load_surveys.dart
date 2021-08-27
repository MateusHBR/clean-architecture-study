import 'package:course_clean_arch/data/http/http.dart';
import 'package:course_clean_arch/data/models/models.dart';
import 'package:course_clean_arch/domain/entities/survey_entity.dart';

import '../../../domain/usecases/usecases.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient<List<Map>> httpClient;
  final String url;

  RemoteLoadSurveys({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<List<SurveyEntity>> call() async {
    final httpResponse = await httpClient.request(
      url: url,
      method: 'get',
    );

    final convertedData = httpResponse
        .map(
          (json) => RemoteSurveysModel.fromJson(json),
        )
        .toList();

    return convertedData
        .map(
          (model) => model.toEntity(),
        )
        .toList();
  }
}
