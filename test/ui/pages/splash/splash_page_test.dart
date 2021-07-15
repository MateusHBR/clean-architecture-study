import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_clean_arch/ui/pages/pages.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final app = MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
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
}
