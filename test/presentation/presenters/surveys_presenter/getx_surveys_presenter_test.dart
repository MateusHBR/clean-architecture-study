import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:course_clean_arch/domain/entities/entities.dart';
import 'package:course_clean_arch/domain/usecases/usecases.dart';

import 'package:course_clean_arch/presentation/presenters/presenters.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

typedef SurveysExpectation = When<Future<List<SurveyEntity>>>;

void main() {
  late GetxSurveysPresenter sut;
  late LoadSurveys loadSurveysSpy;

  setUp(() {
    loadSurveysSpy = LoadSurveysSpy();

    sut = GetxSurveysPresenter(
      loadSurveys: loadSurveysSpy,
    );
  });

  SurveysExpectation mockSurveysCall() {
    return when(() => loadSurveysSpy());
  }

  void mockLoadSurveys() {
    mockSurveysCall().thenAnswer(
      (_) async => [],
    );
  }

  test('should call loadSurveys on loadData', () async {
    mockLoadSurveys();

    await sut.loadData();

    verify(() => loadSurveysSpy()).called(1);
  });
}
