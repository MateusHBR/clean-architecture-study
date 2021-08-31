import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/usecase.dart';

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(
    loadSurveys: makeRemoteLoadSurveys(),
  );
}
