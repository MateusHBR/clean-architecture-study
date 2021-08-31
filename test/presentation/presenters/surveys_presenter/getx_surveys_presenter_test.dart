import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/ui/pages/pages.dart';
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

  final defaultSurveys = [
    SurveyEntity(
      id: '1',
      date: DateTime(2020, 2, 20),
      didAnswered: true,
      question: 'Question1',
    ),
    SurveyEntity(
      id: '2',
      date: DateTime(2021, 2, 20),
      didAnswered: false,
      question: 'Question2',
    ),
  ];

  setUp(() {
    loadSurveysSpy = LoadSurveysSpy();

    sut = GetxSurveysPresenter(
      loadSurveys: loadSurveysSpy,
    );
  });

  SurveysExpectation mockSurveysCall() {
    return when(() => loadSurveysSpy());
  }

  void mockLoadSurveys({List<SurveyEntity>? data}) {
    mockSurveysCall().thenAnswer((_) async => data ?? defaultSurveys);
  }

  void mockLoadSurveysError(DomainError error) {
    mockSurveysCall().thenThrow(error);
  }

  test('should call loadSurveys on loadData', () async {
    mockLoadSurveys();

    await sut.loadData();

    verify(() => loadSurveysSpy()).called(1);
  });

  test('should emit correct events on success', () async {
    mockLoadSurveys();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(
      expectAsync1(
        (surveys) => expect(
          surveys,
          [
            SurveyViewModel(
              id: '1',
              date: '20 Feb 2020',
              didAnswered: true,
              question: 'Question1',
            ),
            SurveyViewModel(
              id: '2',
              date: '20 Feb 2021',
              didAnswered: false,
              question: 'Question2',
            ),
          ],
        ),
      ),
    );

    await sut.loadData();
  });

  test('should emit correct events on error', () async {
    mockLoadSurveysError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(
          error,
          DomainError.unexpected,
        ),
      ),
    );

    await sut.loadData();
  });
}
