import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;

  setUp(() {
    presenter = SurveysPresenterSpy();

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

  testWidgets('should call LoadSurveys on page load', (tester) async {
    await loadWidget(tester);

    verify(() => presenter.loadData()).called(1);
  });
}
