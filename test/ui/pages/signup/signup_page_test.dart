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
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<String?> mainErrorController;

  void initializeStreams() {
    isFormValidController = StreamController<bool>.broadcast();
    isLoadingController = StreamController<bool>.broadcast();
    nameErrorController = StreamController<String?>.broadcast();
    emailErrorController = StreamController<String?>.broadcast();
    passwordErrorController = StreamController<String?>.broadcast();
    passwordConfirmationErrorController = StreamController<String?>.broadcast();
    mainErrorController = StreamController<String?>.broadcast();
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

    when(
      () => presenter.isFormValidStream,
    ).thenAnswer(
      (_) => isFormValidController.stream,
    );
    when(
      () => presenter.isLoadingStream,
    ).thenAnswer(
      (_) => isLoadingController.stream,
    );

    when(
      () => presenter.mainErrorStream,
    ).thenAnswer(
      (_) => mainErrorController.stream,
    );
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
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

  testWidgets(
    'should present error if name is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      nameErrorController.add('any error');

      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );
  testWidgets(
    'should present no error if name is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      nameErrorController.add(null);

      await tester.pump();

      final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.name),
        matching: find.byType(Text),
      );

      expect(
        nameTextChildren,
        findsOneWidget,
      );

      await loadPage(tester);

      nameErrorController.add('');

      await tester.pump();

      expect(
        nameTextChildren,
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

      await loadPage(tester);

      passwordErrorController.add('');

      await tester.pump();

      expect(
        passwordTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present error if passwordConfirmation is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add('any error');

      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );
  testWidgets(
    'should present no error if passwordConfirmation is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add(null);

      await tester.pump();

      final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.passwordConfirmation),
        matching: find.byType(Text),
      );

      expect(
        passwordConfirmationTextChildren,
        findsOneWidget,
      );

      await loadPage(tester);

      passwordConfirmationErrorController.add('');

      await tester.pump();

      expect(
        passwordConfirmationTextChildren,
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
        () => presenter.signUp(),
      ).thenAnswer(
        (_) async {},
      );

      final signupButton = find.byType(ElevatedButton);

      isFormValidController.add(true);
      await tester.pump();
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      verify(() => presenter.signUp()).called(1);
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
    'should present error message if signup fails',
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add('main error');
      await tester.pump();

      expect(find.text('main error'), findsOneWidget);
    },
  );
}
