import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String?>();

    when(
      () => presenter.emailErrorStream,
    ).thenAnswer(
      (_) => emailErrorController.stream,
    );

    final loginPage = MaterialApp(
      home: LoginPage(
        presenter: presenter,
      ),
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
  });

  testWidgets(
    'should load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );
      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            "When a textFormField has only one text child, means it has no errors, since one of the child is always the label text",
      );

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
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
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(() => presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
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
        of: find.bySemanticsLabel('Email'),
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
        of: find.bySemanticsLabel('Email'),
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
        of: find.bySemanticsLabel('Email'),
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
}
