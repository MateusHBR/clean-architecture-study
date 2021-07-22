import 'dart:async';

import 'package:course_clean_arch/utils/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:course_clean_arch/ui/pages/pages.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = MaterialApp(
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignUpPage(),
      },
    );
    await tester.pumpWidget(signUpPage);
  }

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
}
