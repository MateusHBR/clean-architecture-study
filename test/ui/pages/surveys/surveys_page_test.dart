import 'dart:async';

import 'package:course_clean_arch/domain/helpers/helpers.dart';
import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<SurveysState> loadSurveysController;

  void initializeStreams() {
    isLoadingController = StreamController<bool>();
    loadSurveysController = StreamController<SurveysState>();
  }

  void mockStreams() {
    when(
      () => presenter.isLoadingStream,
    ).thenAnswer(
      (invocation) => isLoadingController.stream,
    );
    when(
      () => presenter.surveysStream,
    ).thenAnswer(
      (invocation) => loadSurveysController.stream,
    );
  }

  setUp(() {
    presenter = SurveysPresenterSpy();

    initializeStreams();
    mockStreams();

    when(
      () => presenter.loadData(),
    ).thenAnswer(
      (_) async {},
    );
  });

  Future<void> loadWidget(WidgetTester tester) async {
    final surveysPage = MaterialApp(
      home: SurveysPage(
        presenter: presenter,
      ),
    );

    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() {
    return [
      SurveyViewModel(
        id: '1',
        question: 'Question 1',
        date: 'Date 1',
        didAnswered: true,
      ),
      SurveyViewModel(
        id: '2',
        question: 'Question 2',
        date: 'Date 2',
        didAnswered: false,
      ),
    ];
  }

  void closeStreams() {
    loadSurveysController.close();
    isLoadingController.close();
  }

  tearDown(() {
    // this method is called before delete the page from the tree
    closeStreams();
  });

  testWidgets('should call LoadSurveys on page load', (tester) async {
    await loadWidget(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('should handle load correctly', (tester) async {
    await loadWidget(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(
      find.byType(CircularProgressIndicator),
      findsOneWidget,
    );

    isLoadingController.add(false);
    await tester.pump();

    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
    );
  });

  testWidgets('should presents error if surveysStream fails', (tester) async {
    await loadWidget(tester);

    loadSurveysController.add(
      SurveysErrorState(errorMessage: DomainError.unexpected.description),
    );
    await tester.pump();

    expect(
      find.text(DomainError.unexpected.description),
      findsOneWidget,
    );
    expect(
      find.text(R.strings.reload),
      findsOneWidget,
    );
  });

  testWidgets('should presents list if surveysStream succeeds', (tester) async {
    await loadWidget(tester);

    loadSurveysController.add(
      SurveysSuccessState(
        surveys: makeSurveys(),
      ),
    );
    await tester.pump();

    expect(
      find.text(R.strings.reload),
      findsNothing,
    );
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('should call loadSurveys on reload button click', (tester) async {
    await loadWidget(tester);

    loadSurveysController.add(
      SurveysErrorState(errorMessage: DomainError.unexpected.description),
    );

    await tester.pump();

    await tester.tap(find.text(R.strings.reload));
    await tester.pump();

    verify(() => presenter.loadData()).called(2);
  });
}
