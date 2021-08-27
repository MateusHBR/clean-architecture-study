import '../../../data/http/http.dart';
import '../../../data/models/models.dart';

import '../../../domain/entities/survey_entity.dart';
import '../../../domain/helpers/helpers.dart';
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
    try {
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
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
