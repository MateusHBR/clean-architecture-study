import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:course_clean_arch/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<String?> nameErrorController;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<String?> passwordConfirmationErrorController;

  void initializeStreams() {
    nameErrorController = StreamController<String?>.broadcast();
    emailErrorController = StreamController<String?>.broadcast();
    passwordErrorController = StreamController<String?>.broadcast();
    passwordConfirmationErrorController = StreamController<String?>.broadcast();
  }

  void mockStreams() {
    when(
      () => presenter.nameErrorStream,
    ).thenAnswer(
      (_) => nameErrorController.stream,
    );

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
      () => presenter.passwordConfirmationErrorStream,
    ).thenAnswer(
      (_) => passwordConfirmationErrorController.stream,
    );
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();

    initializeStreams();
    mockStreams();

    final signUpPage = MaterialApp(
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignUpPage(presenter: presenter),
      },
    );

    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
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

      final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.passwordConfirmation),
        matching: find.byType(Text),
      );
      expect(
        passwordConfirmationTextChildren,
        findsOneWidget,
        reason:
            "When a textFormField has only one text child, means it has no errors, since one of the child is always the label text",
      );

      final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.name),
        matching: find.byType(Text),
      );
      expect(
        nameTextChildren,
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

      final name = faker.person.name();
      await tester.enterText(find.bySemanticsLabel(R.strings.name), name);
      verify(() => presenter.validateName(name));

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
      verify(() => presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(
          find.bySemanticsLabel(R.strings.password), password);
      verify(() => presenter.validatePassword(password));

      await tester.enterText(
          find.bySemanticsLabel(R.strings.passwordConfirmation), password);
      verify(() => presenter.validatePasswordConfirmation(password));
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

      await loadPage(tester);

      emailErrorController.add('');

      await tester.pump();

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );
}
