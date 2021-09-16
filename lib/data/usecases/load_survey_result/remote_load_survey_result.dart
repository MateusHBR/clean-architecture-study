import '../../../data/http/http.dart';
import '../../../data/models/models.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveyResult({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<SurveyResultEntity> call({String? surveyId}) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'get',
      );

      return RemoteSurveyResultModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
