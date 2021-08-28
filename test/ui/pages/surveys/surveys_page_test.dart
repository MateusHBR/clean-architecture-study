import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;
  late StreamController<bool> isLoadingController;

  void initializeStreams() {
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(
      () => presenter.isLoadingStream,
    ).thenAnswer(
      (invocation) => isLoadingController.stream,
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

  void closeStreams() {
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
}
