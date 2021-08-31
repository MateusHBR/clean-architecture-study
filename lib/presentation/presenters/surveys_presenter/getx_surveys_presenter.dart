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
  final _isSurveysObservable = Rx<List<SurveyViewModel>>([]);

  @override
  Stream<bool> get isLoadingStream =>
      _isLoadingObservable.stream as Stream<bool>;

  @override
  Stream<List<SurveyViewModel>> get surveysStream =>
      _isSurveysObservable.stream as Stream<List<SurveyViewModel>>;

  @override
  Future<void> loadData() async {
    _isLoadingObservable.value = true;
    try {
      final response = await loadSurveys();

      _isSurveysObservable.value = response
          .map(
            (survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.date),
              didAnswered: survey.didAnswered,
            ),
          )
          .toList();
    } on DomainError catch (error) {} finally {
      _isLoadingObservable.value = false;
    }
  }
}
