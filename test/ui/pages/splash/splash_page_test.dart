import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenterSpy presenter;

  void mockLoadCurrentAccount() {
    when(
      () => presenter.loadCurrentAccount(),
    ).thenAnswer(
      (invocation) async => {},
    );
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    mockLoadCurrentAccount();

    final app = MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(
              presenter: presenter,
            ),
      },
    );

    await tester.pumpWidget(app);
  }

  testWidgets(
    'should present spinner on page load',
    (WidgetTester tester) async {
      await loadPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('should call loadCurrentAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(
      () => presenter.loadCurrentAccount(),
    ).called(1);
  });
}
