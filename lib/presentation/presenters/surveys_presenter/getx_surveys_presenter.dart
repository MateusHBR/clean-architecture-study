import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

import '../../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({
    required this.loadSurveys,
  });

  final _isLoadingObservable = Rx<bool>(true);
  final _isSurveysObservable = Rx<SurveysState>(SurveysInitialState());

  @override
  Stream<bool> get isLoadingStream =>
      _isLoadingObservable.stream as Stream<bool>;

  @override
  Stream<SurveysState> get surveysStream =>
      _isSurveysObservable.stream as Stream<SurveysState>;

  @override
  Future<void> loadData() async {
    _isLoadingObservable.value = true;
    try {
      final response = await loadSurveys();

      _isSurveysObservable.value = SurveysSuccessState(
        surveys: response
            .map(
              (survey) => SurveyViewModel(
                id: survey.id,
                question: survey.question,
                date: DateFormat('dd MMM yyyy').format(survey.date),
                didAnswer: survey.didAnswer,
              ),
            )
            .toList(),
      );
    } on DomainError catch (error) {
      _isSurveysObservable.value = SurveysErrorState(
        errorMessage: error.description,
      );
    } finally {
      _isLoadingObservable.value = false;
    }
  }
}
