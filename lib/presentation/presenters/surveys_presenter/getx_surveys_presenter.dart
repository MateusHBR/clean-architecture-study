import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:get/state_manager.dart';

import 'package:course_clean_arch/domain/usecases/usecases.dart';

import '../../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({
    required this.loadSurveys,
  });

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  Future<void> loadData() async {
    try {
      await loadSurveys();
    } on DomainError catch (error) {}
  }

  @override
  // TODO: implement loadSurveysStream
  Stream<List<SurveyViewModel>> get loadSurveysStream =>
      throw UnimplementedError();
}
