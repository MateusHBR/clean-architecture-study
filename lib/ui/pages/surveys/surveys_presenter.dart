import 'states/surveys_state.dart';
import 'survey_view_model.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<SurveysState> get surveysStream;

  Future<void> loadData();
}
