import 'dart:async';

import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

class NavigatorObserverSpy extends Mock implements NavigatorObserver {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<String> mainErrorController;
  late StreamController<String?> pushNamedAndRemoveUntilStream;
  late NavigatorObserverSpy navigatorObserver;

  void initializeStreams() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<String>();
    pushNamedAndRemoveUntilStream = StreamController<String?>();
  }

  void mockStreams() {
    when(
      () => presenter.emailErrorStream,
    ).thenAnswer(
      (_) => emailErrorController.stream,
    );

    when(
      () => presenter.passwordErrorStream,
    ).thenAnswer(
      (_) => passwordErrorController.stream,
    );

    when(
      () => presenter.isFormValidStream,
    ).thenAnswer(
      (_) => isFormValidController.stream,
    );

    when(
      () => presenter.isLoadingStream,
    ).thenAnswer(
      (invocation) => isLoadingController.stream,
    );

    when(
      () => presenter.errorStream,
    ).thenAnswer(
      (invocation) => mainErrorController.stream,
    );

    when(
      () => presenter.pushNamedAndRemoveUntilStream,
    ).thenAnswer(
      (invocation) => pushNamedAndRemoveUntilStream.stream,
    );
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    pushNamedAndRemoveUntilStream.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    navigatorObserver = NavigatorObserverSpy();

    initializeStreams();
    mockStreams();

    final loginPage = MaterialApp(
      navigatorObservers: [
        navigatorObserver,
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(presenter: presenter),
        '/surveys': (context) => Scaffold(body: Text('Enquetes')),
      },
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    // this method is called before delete the page from the tree
    closeStreams();
  });

  testWidgets(
    'should load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text),
      );
      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            "When a textFormField has only one text child, means it has no errors, since one of the child is always the label text",
      );

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text),
      );
      expect(
        passwordTextChildren,
        findsOneWidget,
        reason:
            "When a textFormField has only one text child, means it has no errors, since one of the child is always the label text",
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, null);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      when(
        () => presenter.validateEmail(any()),
      ).thenAnswer(
        (_) {},
      );

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
      verify(() => presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(
          find.bySemanticsLabel(R.strings.password), password);
      verify(() => presenter.validatePassword(password));
    },
  );

  testWidgets(
    'should present error if email is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');

      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'should present no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);

      await tester.pump();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('');

      await tester.pump();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present no error if email is valid after beeing invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text),
      );

      emailErrorController.add('any error');

      await tester.pump();

      expect(
        emailTextChildren,
        findsNWidgets(2),
      );

      emailErrorController.add(null);

      await tester.pump();

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present error if password is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');

      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'should present no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);

      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text),
      );

      expect(
        passwordTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');

      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text),
      );

      expect(
        passwordTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present no error if password is valid after beeing invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text),
      );

      passwordErrorController.add('any error');

      await tester.pump();

      expect(
        passwordTextChildren,
        findsNWidgets(2),
      );

      passwordErrorController.add(null);

      await tester.pump();

      expect(
        passwordTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should enable button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);

      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'should disable button if form is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);

      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);
    },
  );

  testWidgets(
    'should call authentication on form submit',
    (WidgetTester tester) async {
      await loadPage(tester);

      when(
        () => presenter.authenticate(),
      ).thenAnswer(
        (_) async {},
      );

      isFormValidController.add(true);
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => presenter.authenticate()).called(1);
    },
  );

  testWidgets(
    'should present loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should not presents loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'should present error message if authentication fails',
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add('main error');
      await tester.pump();

      expect(find.text('main error'), findsOneWidget);
    },
  );

  testWidgets(
    'should close streams on dispose',
    (WidgetTester tester) async {
      await loadPage(tester);

      addTearDown(() {
        verify(presenter.dispose).called(1);
      });
    },
  );

  testWidgets(
    'should change page',
    (WidgetTester tester) async {
      await loadPage(tester);
      final newPage = '/surveys';

      when(
        () => navigatorObserver.navigator!.pushNamedAndRemoveUntil(
          newPage,
          (route) => false,
        ),
      ).thenAnswer((_) async => {});

      pushNamedAndRemoveUntilStream.add(newPage);

      await tester.pumpAndSettle();

      expect(find.text('Enquetes'), findsOneWidget);
    },
  );
}
