import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

class NavigatorObserverSpy extends Mock implements NavigatorObserver {}

void main() {
  late SplashPresenterSpy presenter;
  late NavigatorObserverSpy navigatorObserver;
  late StreamController<String?> pushReplacementController;

  void mockLoadCurrentAccount() {
    when(
      () => presenter.checkAccount(),
    ).thenAnswer(
      (invocation) async => {},
    );
  }

  void mockStream() {
    when(
      () => presenter.pushReplacementStream,
    ).thenAnswer(
      (invocation) => pushReplacementController.stream,
    );
  }

  tearDown(() {
    pushReplacementController.close();
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    navigatorObserver = NavigatorObserverSpy();
    pushReplacementController = StreamController<String>();

    mockLoadCurrentAccount();
    mockStream();

    final app = MaterialApp(
      initialRoute: '/',
      navigatorObservers: [
        navigatorObserver,
      ],
      routes: {
        '/': (context) => SplashPage(
              presenter: presenter,
            ),
        '/any_route': (context) => Scaffold(
              body: Text('fake page'),
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
      () => presenter.checkAccount(),
    ).called(1);
  });

  testWidgets('should change page', (WidgetTester tester) async {
    await loadPage(tester);

    pushReplacementController.add('/any_route');

    await tester.pumpAndSettle();

    verify(
      () => navigatorObserver.didReplace(
        newRoute: any(named: 'newRoute'),
        oldRoute: any(named: 'oldRoute'),
      ),
    ).called(1);

    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    pushReplacementController.add('');
    await tester.pump();
    verifyNever(
      () => navigatorObserver.didReplace(
        newRoute: any(named: 'newRoute'),
        oldRoute: any(named: 'oldRoute'),
      ),
    );
  });
}
